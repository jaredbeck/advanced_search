require 'advanced_search/adapters/pg/query'

module AdvancedSearch
  module Adapters
    module PG
      class Visitor
        def initialize(placeholder_style)
          @placeholder_style = placeholder_style
          @sql = []
          @binds = []
        end

        def result
          Query.new(@sql.join(' '), @binds)
        end

        def visit_and(node)
          @sql << '('
          node.edges.each_with_index do |child, i|
            unless i.zero?
              @sql << 'and'
            end
            child.accept(self)
          end
          @sql << ')'
        end

        def visit_eq(node)
          node.edges[0].accept(self)
          @sql << '='
          node.edges[1].accept(self)
        end

        def visit_id(node)
          @sql << node.id
        end

        def visit_lt(node)
          node.edges[0].accept(self)
          @sql << '<'
          node.edges[1].accept(self)
        end

        def visit_or(node)
          @sql << '('
          node.edges.each_with_index do |child, i|
            unless i.zero?
              @sql << 'or'
            end
            child.accept(self)
          end
          @sql << ')'
        end

        def visit_value(node)
          @sql << placeholder(@binds.length + 1)
          @binds << node.value
        end

        private

        def placeholder(ordinal_number)
          case @placeholder_style
          when :question_marks
            '?'
          when :dollars
            format('$%d', ordinal_number)
          else
            raise 'Invalid placeholder style'
          end
        end
      end
    end
  end
end
