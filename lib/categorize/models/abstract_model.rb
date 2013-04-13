# encoding: utf-8

module Categorize
  module Models
    class AbstractModel
      require 'ai4r'

      def initialize
        @gram_cache = Hash.new(nil)
        @bigram_max_cache = Hash.new(nil)
      end

      def build_vars(records_to_tokens)
        @tokens = records_to_tokens.values
        @labels, @vectors = vectorize(@tokens)
        build_dataset(@labels, @vectors)
      end

      def vectorize(token_groups)
        labels = token_groups.flatten.uniq
        vectors = token_groups.reduce([]) do |ary, tokens|
          items = Array.new(labels.length, 0)
          labels.each_with_index do |token, i|
            items[i] = tokens.count(token)
          end
          ary << items
        end
        [labels, vectors]
      end

      def build_dataset(labels, vectors)
        Ai4r::Data::DataSet.new(data_items: vectors, data_labels: labels)
      end
    end
  end
end
