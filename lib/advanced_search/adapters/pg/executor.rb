require 'pg'
require 'advanced_search/adapters/pg/visitor'

module AdvancedSearch
  module Adapters
    module PG
      class Executor
        def initialize(base_query, ast, connection)
          @base_query = base_query
          @ast = ast
          @connection = connection
        end

        def execute
          visitor = Visitor.new(:dollars)
          @ast.accept(visitor)
          query = visitor.result
          sql = [@base_query, query.body].join(' where ')
          @connection.exec_params(sql, query.params)
        end
      end
    end
  end
end
