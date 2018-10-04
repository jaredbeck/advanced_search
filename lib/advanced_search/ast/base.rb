module AdvancedSearch
  module AST
    class Base
      def initialize
        @edges = []
      end

      def add_edge(other_node)
        @edges.push(other_node)
      end
    end
  end
end
