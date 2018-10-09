require "advanced_search/error"

module AdvancedSearch
  module SExp
    # A nicer presentation of a `NameError`.
    #
    # @api public
    class InvalidType < ::AdvancedSearch::Error
      # @api private
      def initialize(type, name_error)
        @type = type
        @name_error = name_error
      end

      # @api public
      # @return String
      def message
        format(
          'Invalid S-expression type: %s (%s) Valid types are: %s',
          @type,
          @name_error.message,
          valid_types.join(', ')
        )
      end

      private

      # @api private
      def valid_types
        AST.constants.reject { |sym| sym == :Base }.map { |sym| sym.to_s.downcase }
      end
    end
  end
end
