module AdvancedSearch
  module Adapters
    module ActiveRecord
      class Visitor
        E_BASE_QUERY_TYPE = 'Visitor expected base_query to be a Relation, got %s'

        def initialize(base_query)
          unless base_query.is_a?(::ActiveRecord::Relation)
            raise ::TypeError, format(E_BASE_QUERY_TYPE, base_query.class.name)
          end
          @base_query = base_query
          @result = base_query.dup
        end

        attr_reader :result

        def visit_and(node)
          node.edges.each do |child|
            @result = @result.merge(child.accept(self))
          end
        end

        def visit_eq(node)
          left = node.edges[0].accept(self)
          right = node.edges[1].accept(self)
          @base_query.where(left => right)
        end

        def visit_id(node)
          node.id
        end

        def visit_lt
          left = node.edges[0].accept(self)
          right = node.edges[1].accept(self)
          @base_query.where('? < ?', left, right)
        end

        def visit_or(node)
          node.edges.each do |child|
            operand = child.accept(self)
            @result = @result.or(operand)
          end
        end

        def visit_value(node)
          node.value
        end
      end
    end
  end
end
