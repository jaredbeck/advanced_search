module AdvancedSearch
  module AST
    class Base
      def initialize
        @edges = []
      end

      attr_reader :edges

      def add_edge(other_node)
        unless other_node.is_a?(Base)
          raise(
            TypeError,
            format(
              'Invalid AST edge. Expected AdvancedSearch::AST::Base, got %s',
              other_node
            )
          )
        end
        @edges.push(other_node)
      end
    end
  end
end
