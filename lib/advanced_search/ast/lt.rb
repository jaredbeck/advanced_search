require "advanced_search/ast/base"

module AdvancedSearch
  module AST
    class Lt < Base
      def accept(visitor)
        @edges[0].accept(visitor)
        visitor.visit_lt
        @edges[1].accept(visitor)
      end
    end
  end
end
