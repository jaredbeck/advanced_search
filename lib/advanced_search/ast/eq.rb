require "advanced_search/ast/base"

module AdvancedSearch
  module AST
    class Eq < Base
      def accept(visitor)
        @edges[0].accept(visitor)
        visitor.visit_eq
        @edges[1].accept(visitor)
      end
    end
  end
end
