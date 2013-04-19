# encoding: utf-8

module Categorize
  module Models
    describe Cluster do
      before :each do
        @cluster = Cluster.new
        @query = DocumentHelper::Query
        @records_to_tokens = DocumentHelper.records_to_tokens
      end

      it 'should build categories' do
        categories_records = Hash[@cluster.model(@query, @records_to_tokens)]

        num_records = @records_to_tokens.length
        categories_records.length.should eq(num_records)
        tokens_as_string = @records_to_tokens.values.flatten.join(' ')

        categories_records.each do |category, records|
          records.each do |record|
            (0...num_records).should include(record)
          end
          tokens_as_string.should include(category)
        end
      end

      it 'should apply the model' do
        documents = DocumentHelper::Helioid
        clusterer = Models::Cluster.new
        clusterer.num_clusters = 3

        results = Hash[Model.make_model('helioid', documents, clusterer)]

        puts "#{results}"

        results.length.should eq(3)
      end
    end
  end
end
