require "advanced_search/ast/base"

module AdvancedSearch
  module AST
    class And < Base
      def accept(visitor)
        visitor.visit_and(self)
      end
    end
  end
end
