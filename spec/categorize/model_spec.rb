# encoding: utf-8

require 'spec_helper'

module Categorize
  describe Model do
    before :each do
      documents = DocumentHelper::Documents

      @doc_multiplier = 5
      @strings = documents.join(' ').downcase
      @documents = documents * @doc_multiplier
    end

    it 'categorizes based on number of documents' do
      query = DocumentHelper::Query
      results = Model.make_model(query, @documents)

      results.each do |category, documents|
        @strings.should include(category)
        @doc_multiplier.should eq(documents.length)
      end
    end

    it 'consider max bucket setting' do
      documents = DocumentHelper::Helioid
      bag_of_words = Models::BagOfWords.new
      bag_of_words.max_buckets = 3
      bag_of_words.min_support = 0.4

      results = Model.make_model('helioid', documents, bag_of_words)

      results.values.flatten.min.should eq(0)
      results.length.should eq(3)
    end

    it 'categorizes using C version' do
      results = Model.make_model_c(@documents)

      results.values.flatten.min.should eq(0)
      results.length.should eq(3)
    end
  end
end
