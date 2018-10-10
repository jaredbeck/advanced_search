require "advanced_search/ast/base"

module AdvancedSearch
  module AST
    class Or < Base
      def accept(visitor)
        visitor.visit_or(self)
      end
    end
  end
end
