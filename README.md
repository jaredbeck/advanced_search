# Prototype

Ruby database **query builder for search queries**. For example, library catalog,
employee phonebook, non-aggregate reports.

- **Simple, not easy.** You'll have to write substantial code to get started, but
  future changes will be simple.
- Requires basic understanding of graph theory, must know what a tree is.
- **Agnostic**: Support for specific databases and ORMs is provided via plugins.
- **No dependencies**
- Unit tests of your search objects do not need to touch database, so they
  are very fast.

## Example 1: Employee Phonebook

Given a `Hash` of parameters from an HTTP form, build a search query.

```ruby
# You write one of these classes for each search form in your application.
# You write this class however you want to. This is one pattern I like.
class PhonebookSearch
  def initialize
    # We will be building a tree, and the head node is an N-ary
    # conjunction. Conjunction is the most common type of search. Disjunction
    # is also common.
    @head = ::Prototype::Nodes::And.new

    # Later, we'll traverse that tree using a visitor that knows how to build
    # a query for use with the mysql2 gem. Many other visitors are available.
    # If you switch databases in the future, you only change the visitor, you
    # don't change anything else in this class.
    @visitor = ::Prototype::Visitors::Mysql2.new
  end

  # Example params:
  #
  # {
  #   age_lt: 40,
  #   ssn_eq: '123-45-6789'
  # }
  #
  # You can organize your parameters, and name them, however you want. A Hash
  # is common.
  def search(params)
    build_tree(params)
    build_query
  end

  private

  # Build a tree by dynamically `send`ing the parameter name. Given the params
  # above, our tree will look like this:
  #
  #            and
  #         /       \
  #        lt        eq
  #       /  \      /  \
  #     age  40   ssn   '123-45-6789'
  #
  def build_tree(params)
    params.each { |k, v| send(k, v) }
  end

  # You write one method like this for each filter on your search form. After
  # this, our tree looks like:
  #
  #        and
  #         |
  #        lt
  #       /  \
  #     age  40
  #
  def age_lt(v)
    eq = ::Prototype::Nodes::Lt.new
    eq.add_edge(::Prototype::Nodes::Id.new(:age))
    eq.add_edge(::Prototype::Nodes::Value.new(v))
    @head.add_edge(eq)
  end

  def ssn_eq(v)
    eq = ::Prototype::Nodes::Eq.new
    eq.add_edge(::Prototype::Nodes::Id.new(:ssn))
    eq.add_edge(::Prototype::Nodes::Value.new(v))
    @head.add_edge(eq)
  end

  # Returns a query suitable for use with the mysql2 gem, because that's the
  # visitor we selected above.
  def build_query
    @head.accept(@visitor)
    @visitor.result
  end
end
```
