# encoding: utf-8

module Categorize
  module Models
    class Cluster < AbstractModel
      @num_clusters = 10

      def initialize
        @clusterer = Ai4r::Clusterers::WardLinkage.new
        super
      end

      def model(query, records_to_tokens)
        @query = query
        dataset = build_vars(records_to_tokens)
        @clusterer.build(dataset, @num_clusters)
        build_categories(@clusterer.clusters)
      end

      def build_categories(clusters)
        docs_as_indices = clusters.map do |cluster|
          cluster.data_items.map { |v| @vectors.index(v) }
        end
        nums_to_docs = (0..(@num_clusters - 1)).zip(docs_as_indices)
        clusters_to_records = Hash[nums_to_docs]

        @query_terms ||= @query.split.map(&:downcase)

        categories = clusters_to_records.map do |cluster, records|
          term_vectors = records.map { |r| @vectors[r] }.transpose
          tf = term_vectors.map { |f| f.reduce(&:+) }
          get_bigram_max(records, tf)
        end

        records = clusters_to_records.values
        # merge duplicate labeled categories
        categories_records = []
        categories.each_with_index do |category, i|
          if j = categories[0...i].index(category) && categories_records[j]
            categories_records[j].last + records.shift
          else
            categories_records << [category, records.shift]
          end
        end
        categories_records
      end

      private
        def df(term_vectors)
          term_vectors.map do |f|
            f.reduce { |count, tf| tf > 0 ? count + 1 : count }
          end.flatten
        end

        def get_bigram_max(records, tf, df = false)
          @bigram_max_cache[[records, tf, df]] ||= bigram_max(records, tf, df)
        end

        def bigram_max(records, tf, df)
          bigrams = records.map { |r| get_grams(r) }.flatten.uniq
          bigrams.max_by do |b|
            b_terms = b.split
            if b == @query || b_terms.include?(@query) ||
              b_terms.any? { |t| @query_terms.include?(t) }
              0
            else
              i, j = b_terms.map { |t| @labels.index(t) }
              if df
                df_i, df_j = [i, j].map { |k| df[k] }
                df_i > 0 and df_j > 0 ? (tf[i] / df_i) * (tf[j] / df_j) : 0
              else
                tf[i] * tf[j]
              end
            end
          end
        end

        def unigram_max(records, tf, df = false)
          cluster_terms = records.map { |r| @tokens[r] }.flatten.uniq
          cluster_terms.max_by do |t|
            if t == @query || @query_terms.include?(t)
              0
            else
              i = labels.index(t)
              if df
                df_i = df[i]
                df_i > 0 ? tf[i] / df_i : 0
              else
                tf[i]
              end
            end
          end
        end

        def get_grams(r)
          @gram_cache[r] ||= gramize(@tokens[r])
        end

        def gramize(tokens)
          last_token = nil
          tokens = tokens.map do |token|
            new_token = last_token and last_token != token
            gram = (new_token) ? "#{last_token} #{token}" : nil
            last_token = token
            gram
          end.compact.uniq
        end
    end
  end
end
