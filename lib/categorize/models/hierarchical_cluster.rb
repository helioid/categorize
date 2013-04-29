# encoding: utf-8

module Categorize
  module Models
    class HierarchicalCluster < Cluster
      def initialize
        super
        @depth = 8
        @clusterer = Ai4r::Clusterers::WardLinkageHierarchical.new(@depth)
      end

      def model(query, records_to_tokens)
        dataset = set_vars(query, records_to_tokens)
        @num_clusters = 1
        @clusterer.build(dataset, @num_clusters)
        @num_clusters = 0
        cluster_sets = nil
        cluster_sets = @clusterer.cluster_tree.map do |clusters|
          @num_clusters += 1
          build_categories(clusters)
        end
        cluster_sets
      end
    end
  end
end
