# encoding: utf-8

require 'spec_helper'

module Categorize
  module Models
    describe CBagOfWords do
      before :each do
        @model = CBagOfWords.new
        @documents = DocumentHelper::Documents.map do |s|
          Categorize::Model.preprocess(s)
        end
      end

      it 'should be importable' do
        results = @model.model(@documents)

        results.length.should eq(3)
      end
    end
  end
end
