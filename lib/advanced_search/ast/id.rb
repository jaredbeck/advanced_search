require "advanced_search/ast/base"

module AdvancedSearch
  module AST
    # Trusted. Do not construct an `Id` directly from user input.
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
