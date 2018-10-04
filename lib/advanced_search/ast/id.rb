require "advanced_search/ast/base"

module AdvancedSearch
  module AST
    class Id < Base
      def initialize(id)
        @id = id
      end

      attr_reader :id

      def accept(visitor)
        visitor.visit_id(self)
      end
    end
  end
end
