# encoding: utf-8

module Categorize
  module Model
    MIN_WORD_LENGTH = 3
    @bag_of_words = Models::BagOfWords.new
    @c_bag_of_words = Models::CBagOfWords.new

    class << self
      #include Bow
      # ==== Return
      # Hash - category => results
      # ==== Parameters
      # documents:: a list of documents to be classified
      def make_model(query, documents, modeler = @bag_of_words)
        records_to_tokens = lexicalize(documents)
        modeler.model(query.downcase.strip, records_to_tokens)
      end

      # ==== Return
      # Hash - category => results
      # ==== Parameters
      # items:: the items to be classified
      def make_model_c(strings)
        array_of_tokens = strings.map { |s| preprocess(s) }
        ret = @c_bag_of_words.model(array_of_tokens);
        count = 0
        ret.reduce({}) do |hash, term|
          hash[term] ||= []
          hash[term] << count
          count += 1
          hash
        end
      end

      def lexicalize(strings)
        Hash[
          (0..(strings.length - 1)).zip(strings.map { |s| preprocess(s) })
        ]
      end

      def preprocess(string)
        split_lower_strings = string.split(
            Constants::Words::SPLIT_REGEX).map(&:downcase)
        split_lower_strings.delete_if do |word|
           word.length < MIN_WORD_LENGTH ||
            Constants::Words::COMMON.include?(word)
        end
      end
    end
  end
end
