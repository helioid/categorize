# encoding: utf-8

module Categorize
  MIN_WORD_LENGTH = 3
  @bag_of_words = Models::BagOfWords.new

  class << self
    #include Bow
    # ==== Return
    # Hash - category => results
    # ==== Parameters
    # documents:: a list of documents to be classified
    def make_model(query, documents, topic_model = @bag_of_words)
      records_to_tokens = lexicalize(documents)
      topic_model.model(query.downcase.strip, records_to_tokens)
    end

    # ==== Return
    # Hash - category => results
    # ==== Parameters
    # items:: the items to be classified
    def make_model_c(strings)
      strings.map { |s| preprocess(s) }
      #ret = model_bow(array_of_tokens);
      count = 0
      ret.reduce({}) do |hash, term|
        hash[term] ||= []
        hash[term] << count += 1
        hash
      end
    end

    private
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
