require "advanced_search/sexp/invalid_type"

module AdvancedSearch
  module SExp
    # @api private
    class NodeBuilder
      # @api private
      def initialize(type, *args)
        @type = type
        @args = args
      end

      # @api private
      def build
        constructor_args, child_nodes = split_args
        # puts [@type, @args, constructor_arity, constructor_args, child_nodes].inspect
        node = node_class.new(*constructor_args)
        add_edges(node, child_nodes)
        node
      end

      private

      # @api private
      def add_edges(node, children)
        children.each do |i|
          node.add_edge(i)
        end
      end

        # @api private
      def constructor_arity
        node_class.allocate.method(:initialize).arity
      end

      # @api private
      def node_class
        @_node_class ||= ::Object.const_get(node_class_path)
      rescue ::NameError => e
        raise InvalidType.new(@type, e)
      end

      # @api private
      # @return String - absolute constant path
      def node_class_path
        format('::AdvancedSearch::AST::%s', @type.to_s.capitalize)
      end

      # @api private
      def split_args
        c_arity = constructor_arity
        [
          @args[0, c_arity],
          @args[c_arity..-1]
        ]
      end
    end
  end
end
