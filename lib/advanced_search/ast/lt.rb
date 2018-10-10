require "advanced_search/ast/base"

module AdvancedSearch
  module AST
    class Lt < Base
      def accept(visitor)
        visitor.visit_lt(self)
      end
    end
  end
end
