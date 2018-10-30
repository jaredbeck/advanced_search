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
  include ::AdvancedSearch::SExp::S
  FILTERS = %w[age_lt ssn_eq]

  def search(params)
    execute_query(build_tree(params))
  end

  private

  # Each parameter becomes an operand in an N-ary conjunction.
  def build_tree(params)
    operands = params.map { |k, v| send("filter_#{k}", v) }
    s(:and, *operands)
  end

  # Protect the dynamic `send` with a safelist.
  def filter(k, v)
    if FILTERS.include?(k)
      send("filter_#{k}", v)
    else
      raise "Invalid filter: #{k}"
    end
  end

  # Write one method like this for each filter on your search form.
  def filter_age_lt(v)
    s(:lt,
      s(:id, :age),
      s(:value, v)
    )
  end

  def filter_ssn_eq(v)
    s(:eq,
      s(:id, :ssn),
      s(:value, v)
    )
  end

  # Execute the query using your preferred adapter, in this case, the `pg` gem.
  def execute_query(tree)
    ::AdvancedSearch::Adapters::PG::Executor
      .new(
        # You provide the select clause ..
        'select * from employees',
        
        # .. the `Executor` will build the `where` clause from your AST.
        tree
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
