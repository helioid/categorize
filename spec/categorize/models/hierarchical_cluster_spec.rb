# encoding: utf-8

module Categorize
  module Models
    describe HierarchicalCluster do
      before :each do
        @cluster = HierarchicalCluster.new
        @query = DocumentHelper::Query
        @records_to_tokens = DocumentHelper.records_to_tokens
      end

      it 'should build categories' do
        clusters = @cluster.model(@query, @records_to_tokens)

        num_records = @records_to_tokens.length
        clusters.length.should eq(num_records)
        tokens_as_string = @records_to_tokens.values.flatten.join(' ')

        clusters.each do |cluster|
          cluster.length.should be <= num_records

          cluster.each do |category, records|
            records.each do |record|
              (0...num_records).should include(record)
            end
            tokens_as_string.should include(category)
          end
        end
      end

      it 'should cluster using a hierarchical model' do
        documents = DocumentHelper::Helioid
        hierarchical_model = Models::HierarchicalCluster.new

        results = Model.make_model('helioid', documents, hierarchical_model)

        results.length.should eq(5)
      end
    end
  end
end
