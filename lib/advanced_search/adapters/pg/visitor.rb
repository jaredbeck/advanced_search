require 'advanced_search/adapters/pg/query'

module AdvancedSearch
  module Adapters
    module PG
      class Visitor
        def initialize
          @sql = []
          @binds = []
        end

        def result
          Query.new(@sql.join(' '), @binds)
        end

        def visit_and
          @sql << 'and'
        end

        def visit_eq
          @sql << '='
        end

        def visit_id(node)
          @sql << node.id
        end

        def visit_lt
          @sql << '<'
        end

        def visit_or
          @sql << 'or'
        end

        def visit_value(node)
          @sql << format('$%d', @binds.length + 1)
          @binds << node.value
        end
      end
    end
  end
end
