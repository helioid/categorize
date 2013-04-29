# encoding: utf-8

module Categorize
  module Models
    class Cluster < AbstractModel

      attr_accessor :num_clusters

      def initialize
        @num_clusters = 10
        @clusterer = Ai4r::Clusterers::WardLinkage.new
        super
      end

      def model(query, records_to_tokens)
        dataset = set_vars(query, records_to_tokens)
        @clusterer.build(dataset, @num_clusters)
        build_categories(@clusterer.clusters)
      end

      def set_vars(query, records_to_tokens)
        @query = query
        @query_terms ||= @query.split.map(&:downcase)
        build_vars(records_to_tokens)
      end

      def build_categories(clusters)
        clusters_to_records = map_clusters_to_records(clusters)
        categories = get_fit_categories(clusters_to_records)
        join_categories_and_records(categories, clusters_to_records.values)
      end

      def map_clusters_to_records(clusters)
        Hash[clusters.each_with_index.map do |cluster, i|
          [i, cluster.data_items.map { |v| @vectors.index(v) }]
        end]
      end

      def get_fit_categories(clusters_to_records)
        clusters_to_records.map do |cluster, records|
          term_vectors = records.map { |r| @vectors[r] }.transpose
          tf = term_vectors.map { |f| f.reduce(&:+) }
          get_bigram_max(records, tf)
        end
      end

      def join_categories_and_records(categories, records)
        # merge categories with the same label
        categories_records = []
        categories.each_with_index do |category, i|
          j = categories[0...i].index(category)

          if j && categories_records[j]
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
              # Set the term frequency to zero if it is in the query.
              0
            else
              terms_tf_idf(b_terms, tf, df)
            end
          end
        end

        def terms_tf_idf(b_terms, tf, df)
          i, j = b_terms.map { |t| @labels.index(t) }
          if df
            df_i, df_j = [i, j].map { |k| df[k] }
            df_i > 0 and df_j > 0 ? (tf[i] / df_i) * (tf[j] / df_j) : 0
          else
            tf[i] * tf[j]
          end
        end

        def unigram_max(records, tf, df = false)
          cluster_terms = records.map { |r| @tokens[r] }.flatten.uniq
          cluster_terms.max_by do |t|
            if t == @query || @query_terms.include?(t)
              0
            else
              i = labels.index(t)
              df ? safe_div(tf[i], df[i]) : tf[i]
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

        def safe_div(numerator, denominator)
          denominator != 0 ? numerator / denominator : 0
        end
    end
  end
end
