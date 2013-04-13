# encoding: utf-8

module Categorize
  module Utils
    module Grams
      def create_grams(query, records_to_words)
        all_grams = []
        @query = query
        @query_terms = query.split.map(&:downcase).map(&:strip)
        @query_alt = "#{@query_terms[1..-1]} #{@query_terms[0]}"

        invalid = Proc.new do |gram, *args|
          # remove [[gram]] if == [[query]]
          gram == @query || gram == @query_alt || @query_terms.include?(gram)
        end

        gram_collections = records_to_words.map do |record, words|
          gram_collection = GramCollection.new(record, words, invalid)
          all_grams += gram_collection.grams
          gram_collection
        end
        return gram_collections, make_grams_unique(all_grams)
      end

      def check_plurals(frequent_grams)
        # if exists [[gram]] and [[gram]]s then remove [[gram]]s
        frequent_grams_contents = frequent_grams.map(&:content)
        frequent_grams.delete_if do |gram|
          gram.content[-1] == 's' and
            frequent_grams_contents.include?(gram.content[0...-1])
        end
      end

      def make_grams_unique(grams)
        grams.reduce({}) do |hash, gram|
          if hash[gram.content]
            hash[gram.content].frequency += gram.frequency
          else
            hash[gram.content] = gram
          end
          hash
        end.values
      end
    end
  end
end
