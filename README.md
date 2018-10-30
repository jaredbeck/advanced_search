# AdvancedSearch

Builds database search queries with complex, nested logical expressions.

You provide an [abstract syntax tree][1] representing the search, and
`AdvancedSearch` builds the search clause of the query (eg. the `where`
clause, in SQL).

| *Good for*       | *Not Good For* |
| ---------------- | -------------- |
| searches         | reports        |
| complex logic expressions | simple "conjunction of all parameters" forms |
| natural language | 99% of business search forms |

Input can be natural language,

```
'age less than 40 and ssn equal to 123-45-6789'
```

or a typical HTML form,

```
{
  age_lt: 40,
  ssn_eq: '123-45-6789'
}
```

You organize and name your parameters however you want. You convert those
parameters into an `AdvancedSearch::AST`:

```
       and
    /       \
   lt        eq
  /  \      /  \
age  40   ssn   '123-45-6789'
```

A convenient S-expression syntax is provided to help you build your tree:

```
s(:and,
  s(:lt, s(:id, :age), s(:value, 40),
  s(:eq, s(:id, :ssn), s(:value, '123-45-6789')
)
```

`AdvancedSearch` converts your tree into a parameterized search clause (eg. the
`where` clause, in SQL).

```
'where age < $1 and ssn = $2'
[40, '123-45-6789']
```

Finally, you do whatever you want with that search clause. Prepare a complete
query and execute it using `ActiveRecord`'s [find_by_sql][2] method, perhaps?
Maybe execute it directly using a gem like `pg` or `mysql2`? What you do with
your query, in the privacy of your own home, is your own business.

## Complete Example

There is a complete example using `ActiveRecord`'s [find_by_sql][2] method in
the test suite. See:

```
spec/support/activerecord/models
spec/support/activerecord/searches/library_catalog.rb
spec/activerecord/searches/library_catalog_spec.rb
```

## Adapters

| *adapter*      | *gem*          | *status*            |
| -------------- | -------------- | ------------------- |
| `PG`           | `pg`           | Proof of concept    |
| `Mysql2`       | `mysql2`       | Not yet implemented |
| `ActiveRecord` | `activerecord` | If only ARel had docs |

## Design Goals

- **Simple, not easy.** You'll have to write substantial code to get started,
  but future changes will be simple.
- Requires basic understanding of graph theory, must know what a tree is.
- **Agnostic**: Support for specific databases and ORMs is provided via *adapters*.
- **No dependencies**
- Unit tests of your search objects do not need to touch database, so they
  are very fast.

## Roadmap

- full-text search
- "raw" node?

[1]: https://en.wikipedia.org/wiki/Abstract_syntax_tree
[2]: https://api.rubyonrails.org/classes/ActiveRecord/Querying.html#method-i-find_by_sql
