# encoding: utf-8

require 'categorize/utils/grams'

module Categorize
  module Models
    class BagOfWords
      include Utils::Grams

      # DEBUG = false
      attr_accessor :max_buckets, :min_support, :num_top_grams

      # 0 <= min_support <= 1, we like 0.01 <= min_support <= 0.1
      def initialize
        @max_buckets = 8
        # TODO: some gradient descent to choose this number
        @min_support = 0.07
        @num_top_grams = 250
      end

      # function worst case
      # O(2 x (|frequent_grams| x |gram_collections|) +
      #   |all_grams| + @max_buckets x |gram_collections|)
      def model(query, records_to_tokens)
        @gram_cover_cache = {}
        @gram_collections, @all_grams = create_grams(query, records_to_tokens)

        top_grams = determine_frequency_term_sets(@all_grams, query)
        top_grams = top_grams.keys.sort do |gram_c1, gram_c2|
          top_grams[gram_c1] <=> top_grams[gram_c2]
        end
        top_grams = top_grams.first(@max_buckets)

        find_max_fit(top_grams)
      end

      # function worst case O(@max_buckets x |gram_collections|)
      def find_max_fit(top_grams)
        @gram_collections.reduce({}) do |a, e|
          max_fitness = 0
          max_fit = nil
          top_grams.each do |top_gram|
            # the >= removes the 'none' possibility
            if e.fitness[top_gram] && e.fitness[top_gram] >= max_fitness
              max_fitness = e.fitness[top_gram]
              max_fit = top_gram
            end
          end
          a[max_fit] ||= []
          a[max_fit] << e.content
          a
        end
      end

      # ==== Return
      # Hash - fitness => [gram_collection, ...]
      # function worst case O(2 x (|frequent_grams| x |gram_collections|) +
      #                            |all_grams|)
      def determine_frequency_term_sets(all_grams, query)
        frequent_grams = find_valid_sorted_grams(all_grams)

        # below block, worst case O(|frequent_grams| x |gram_collections|)
        @gram_collections.reduce(Hash.new(0)) do |a, e|
          max_fitness = 0
          max_fit = nil

          frequent_grams.each do |gram|
            content_frequency = (e.content_to_frequency[gram.content] || 0)
            fitness = content_frequency / gram.frequency.to_f
            e.fitness[gram.content] = fitness

            if fitness > max_fitness
              max_fitness = fitness
              max_fit = gram.content
            end
          end

          a[max_fit] += 1 if max_fit
          a
        end
      end

      # function worstcase O(#gram_collections)
      def cover(gram, min_length)
        ((cached = @gram_cover_cache[gram]) != nil) and return cached
        count = 0

        @gram_collections.each do |gram_collection|
          frequency = gram_collection.content_to_frequency[gram.content]
          if !frequency.nil? && frequency > 0
            count += 1
            return @gram_cover_cache[gram] = true if count >= min_length
          end
        end

        @gram_cover_cache[gram] = false
      end

      def min_coverage
        # only count a result if it has non-0 words length
        effective_length = @gram_collections.reject do |result|
          result.grams.nil? || result.grams.empty?
        end.length
        @min_support * effective_length
      end

      def find_valid_sorted_grams(all_grams)
        min_cover = min_coverage

        # for speed only look at top N grams
        # below block, worst case O(|all_grams|)
        frequent_grams = all_grams.sort { |a, b| b.frequency <=> a.frequency }
        frequent_grams = frequent_grams.first(@num_top_grams)

        # below block, worst case O(|frequent_grams| x |gram_collections|)
        frequent_grams.delete_if { |gram| !cover(gram, min_cover) }
      end
    end
  end
end
