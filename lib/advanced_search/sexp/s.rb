require "advanced_search/sexp/node_builder"

module AdvancedSearch
  module SExp
    # S-expressions are a concise way to instantiate AST nodes.
    #
    # ```
    # # This ..
    # eq = ::AdvancedSearch::Nodes::Lt.new
    # eq.add_edge(::AdvancedSearch::Nodes::Id.new(:age))
    # eq.add_edge(::AdvancedSearch::Nodes::Value.new(40))
    #
    # # .. becomes
    # include ::AdvancedSearch::SExp::S
    # eq = s(:lt, s(:id, :age), s(:value, 40))
    # ```
    #
    # You don't have to use S-expressions to use AdvancedSearch, but they are
    # convenient.
    #
    # @api public
    module S
      # A concise way to instantiate AST nodes.
      #
      # ```
      # include ::AdvancedSearch::SExp::S
      # eq = s(:lt, s(:id, :age), s(:value, 40))
      # ```
      #
      # As this method is an important part of the AdvancedSearch API, special
      # care is taken to produce helpful error messages when given incorrect
      # arguments.
      #
      # @api public
      # @param type [String, Symbol] - The basename of a descendent of AST::Base.
      #   E.g. to instantiate an `AST:Eq`, use `'eq'` or `:eq`.
      # @param *args - Arguments for the AST node constructor first. Subsequent
      #   arguments become child nodes.
      def s(type, *args)
        NodeBuilder.new(type, *args).build
      end
    end
  end
end
