# encoding: utf-8

module Categorize
  module Models
    describe BagOfWords do
      before :each do
        @bag_of_words = BagOfWords.new
      end

      it 'should convert documents to buckets' do
        result = @bag_of_words.model('query', {1 => ['doc']})
        result.should eq({'doc' => [1]})
      end
    end
  end
end
