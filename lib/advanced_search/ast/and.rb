require "advanced_search/ast/base"

module AdvancedSearch
  module AST
    class And < Base
      def accept(visitor)
        @edges.each_with_index do |node, i|
          unless i.zero?
            visitor.visit_and
          end
          node.accept(visitor)
        end
      end
    end
  end
end
