# AdvancedSearch

Ruby database **query builder** for advanced search. For example, library
catalog, employee phonebook, non-aggregate reports.

## Example 1: Employee Phonebook

1. User submits a search form with parameters like:

    ```
    {
      age_lt: 40,
      ssn_eq: '123-45-6789'
    }
    ```

    You can organize your parameters, and name them, however you want. A Hash
    like this is common. See other examples below.

2. You write a search class that converts the form parameters into an AST:

    ```
           and
        /       \
       lt        eq
      /  \      /  \
    age  40   ssn   '123-45-6789'
    ```

3. You pass the AST to your preferred database adapter and it executes your query.

```ruby
# You write this class however you want to. This is one pattern I like.
class PhonebookSearch
  def initialize
    # We will build a tree whose head node is an N-ary conjunction.
    @head = ::AdvancedSearch::AST::And.new
  end

  def search(params)
    build_tree(params)
    execute_query
  end

  private

  def build_tree(params)
    params.each { |k, v| send(k, v) }
  end

  # Write one method like this for each filter on your search form.
  def age_lt(v)
    eq = ::AdvancedSearch::Nodes::Lt.new
    eq.add_edge(::AdvancedSearch::Nodes::Id.new(:age))
    eq.add_edge(::AdvancedSearch::Nodes::Value.new(v))
    @head.add_edge(eq)
  end

  def ssn_eq(v)
    eq = ::AdvancedSearch::Nodes::Eq.new
    eq.add_edge(::AdvancedSearch::Nodes::Id.new(:ssn))
    eq.add_edge(::AdvancedSearch::Nodes::Value.new(v))
    @head.add_edge(eq)
  end

  # Execute the query using your preferred adapter, in this case, ActiveRecord.
  def execute_query
    ::AdvancedSearch::Adapters::ActiveRecord::Executor
      .new(
        # Use whatever "starting point" you like ..
        ::Employee.active,
        
        # .. the `Executor` will (in this case) use your AST for the `where` clause.
        @head
      )
      .execute
  end
end
```

## Example 2: Semi-natural query language

1. User submits a single search form parameter like:

    ```
    {
      natural_query: 'age less than 40 and ssn equal to 123-45-6789'
    }
    ```

2. This is fine, if you can parse this into an `AdvancedSearch::AST`, you can
  execute the query using any of the provided adapters, as shown in Example 1.

## Adapters

| *adapter*      | *gem*          | *status*            |
| -------------- | -------------- | ------------------- |
| `ActiveRecord` | `activerecord` | Not yet implemented |
| `Mysql2`       | `mysql2`       | Not yet implemented |
| `PG`           | `pg`           | Proof of concept    |

## Design Goals

- **Simple, not easy.** You'll have to write substantial code to get started,
  but future changes will be simple.
- Requires basic understanding of graph theory, must know what a tree is.
- **Agnostic**: Support for specific databases and ORMs is provided via plugins.
- **No dependencies**
- Unit tests of your search objects do not need to touch database, so they
  are very fast.

## Roadmap

- Move the adapters into separate gems
- AST support for:
  - associations (`join`s)
  - full-text search
  - "raw" node
