# bin/console
# irb(main):001:0> Prototype::Junctive::Client.new(:or).perform(age_lt: 40, ssn_eq: '123-45-6789')
#          InsecureSql -> age < 40 or ssn = 123-45-6789
#             BoundSql -> ["age < $1 or ssn = $2", [40, "123-45-6789"]]
#            BananaSql -> 🍌 < 🍌 or 🍌 = 🍌
# => nil

module Prototype
  module Junctive
    module Nodes
      class Base
        def initialize
          @edges = []
        end

        def add_edge(other_node)
          @edges.push(other_node)
        end
      end

      class And < Base
        def accept(visitor)
          @edges.each_with_index do |node, i|
            unless i.zero?
              visitor.visit_and
            end
            node.accept(visitor)
          end
        end
      end

      class Eq < Base
        def accept(visitor)
          @edges[0].accept(visitor)
          visitor.visit_eq
          @edges[1].accept(visitor)
        end
      end

      class Id < Base
        def initialize(id)
          @id = id
        end

        attr_reader :id

        def accept(visitor)
          visitor.visit_id(self)
        end
      end

      class Lt < Base
        def accept(visitor)
          @edges[0].accept(visitor)
          visitor.visit_lt
          @edges[1].accept(visitor)
        end
      end

      class Or < Base
        def accept(visitor)
          @edges.each_with_index do |node, i|
            unless i.zero?
              visitor.visit_or
            end
            node.accept(visitor)
          end
        end
      end

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

    module Visitors
      class Sql
        def initialize
          @sql = []
        end

        def visit_and
          @sql << 'and'
        end

        def visit_eq
          @sql << '='
        end

        def visit_lt
          @sql << '<'
        end

        def visit_or
          @sql << 'or'
        end
      end

      class BoundSql < Sql
        def initialize
          super
          @binds = []
        end

        def result
          [@sql.join(' '), @binds]
        end

        def visit_id(node)
          @sql << node.id
        end

        def visit_value(node)
          @sql << format('$%d', @binds.length + 1)
          @binds << node.value
        end
      end

      # Vulnerable to SQL-injection
      class InsecureSql < Sql
        def initialize
          @sql = []
        end

        def result
          @sql.join(' ')
        end

        def visit_id(node)
          @sql << node.id
        end

        def visit_value(node)
          @sql << node.value
        end
      end

      class BananaSql < Sql
        def initialize
          @sql = []
        end

        def result
          @sql.join(' ')
        end

        def visit_id(_node)
          @sql << '🍌'
        end

        def visit_value(_node)
          @sql << '🍌'
        end
      end
    end

    class Client
      # The head of the tree is either a conjunction or disjunction, depending
      # on `operator`.
      def initialize(operator)
        @head = get_head(operator)
      end

      def perform(params)
        # Build a graph (tree) by dynamically `send`ing the parameter name.
        params.each { |k, v| send(k, v) }

        # Now, we have a graph (tree) which we can iterate (DFS) using whichever
        # visitor we feel like using.
        traverse(Visitors::InsecureSql)
        traverse(Visitors::BoundSql)
        traverse(Visitors::BananaSql)
      end

      private

      def age_lt(v)
        eq = Nodes::Lt.new
        eq.add_edge(Nodes::Id.new(:age))
        eq.add_edge(Nodes::Value.new(v))
        @head.add_edge(eq)
      end

      def get_head(operator)
        case operator
        when :and
          Nodes::And.new
        when :or
          Nodes::Or.new
        else
          raise 'invalid operator'
        end
      end

      def ssn_eq(v)
        eq = Nodes::Eq.new
        eq.add_edge(Nodes::Id.new(:ssn))
        eq.add_edge(Nodes::Value.new(v))
        @head.add_edge(eq)
      end

      def traverse(visitor_class)
        visitor = visitor_class.new
        @head.accept(visitor)
        puts format('%20s -> %s', visitor_class.name.split('::').last, visitor.result)
        nil
      end
    end
  end
end
