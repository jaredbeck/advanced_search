require "advanced_search/ast/base"

module AdvancedSearch
  module AST
    class Value < Base
      def initialize(value)
        @value = value
      end

      attr_reader :value

      def accept(visitor)
        visitor.visit_value(self)
      end
    end
  end
end
