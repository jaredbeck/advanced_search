require "advanced_search/ast/base"

module AdvancedSearch
  module AST
    class Eq < Base
      def accept(visitor)
        visitor.visit_eq(self)
      end
    end
  end
end
