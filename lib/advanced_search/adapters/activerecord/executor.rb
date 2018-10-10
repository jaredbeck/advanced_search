require 'advanced_search/adapters/activerecord/visitor'

module AdvancedSearch
  module Adapters
    module ActiveRecord
      class Executor
        # @api public
        def initialize(base_query, ast)
          @base_query = base_query
          @ast = ast
        end

        # @api public
        def execute
          visitor = Visitor.new(@base_query)
          @ast.accept(visitor)
          visitor.result
        end
      end
    end
  end
end
