# encoding: utf-8

require 'spec_helper'

module Categorize
  describe Model do
    before :each do
      documents = DocumentHelper::Documents

      @doc_multiplier = 5
      @strings = documents.join(' ').downcase.split(/\W/)
      @documents = documents * @doc_multiplier
    end

    it 'categorizes based on number of documents' do
      query = 'test'
      results = Model.make_model(query, @documents)

      results.each do |category, documents|
        @strings.should include(category)
        @doc_multiplier.should eq(documents.length)
      end
    end
  end
end
