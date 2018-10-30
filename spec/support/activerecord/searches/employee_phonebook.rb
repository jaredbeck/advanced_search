require 'set'

class EmployeePhonebook
  include ::AdvancedSearch::SExp::S
  FILTERS = %w[
    age_lt
    department_name_eq
    ssn_eq
  ]

  def initialize(params)
    @params = params
    @joins = ::Set.new
  end

  def search
    execute_query(build_tree)
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

  def filter_department_name_eq(v)
    @joins.add(:department)
    s(:eq,
      s(:id, :ssn),
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
  # You provide the select clause and the adapter's `Executor` will build the
  # `where` clause from your AST.
  def execute_query(tree)
    base_query = 'select * from employees'
    if @joins.include?(:department)
      base_query += ' inner join departments on departments.id = employees.department_id'
    end
    ::AdvancedSearch::Adapters::PG::Executor
      .new(base_query, tree)
      .execute
  end
end
