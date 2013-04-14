# encoding: utf-8

module Categorize
  module Models
    describe BagOfWords do
      before :each do
        @bag_of_words = BagOfWords.new
        @query = DocumentHelper::Query
        @records_to_tokens = DocumentHelper.records_to_tokens
      end

      it 'should convert documents to buckets' do
        result = @bag_of_words.model('query', {1 => ['doc']})
        result.should eq({'doc' => [1]})
      end

      it 'should assign categories and documents within records' do
        result = @bag_of_words.model(@query, @records_to_tokens)
        num_results = @records_to_tokens.length
        tokens_as_string = @records_to_tokens.values.flatten.join(' ')

        result.each do |category, documents|
          documents.each do |document|
            (0...num_results).should include(document)
          end

          tokens_as_string.should include(category)
        end
      end
    end
  end
end
