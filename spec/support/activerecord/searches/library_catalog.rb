require 'advanced_search/adapters/pg/visitor'

class LibraryCatalog
  include ::AdvancedSearch::SExp::S
  FILTERS = %w[
    author_name_eq
    title_eq
  ]

  def initialize(params)
    @params = params
    @joins = ::Set.new
  end

  def search
    execute_query(build_tree)
  end

  private

  def build_tree
    operands = @params.map { |k, v| send("filter_#{k}", v) }
    s(:and, *operands)
  end

  def filter(k, v)
    if FILTERS.include?(k)
      send("filter_#{k}", v)
    else
      raise "Invalid filter: #{k}"
    end
  end

  def filter_author_name_eq(v)
    @joins.add(:authors)
    s(:eq, s(:id, 'authors.name'), s(:value, v))
  end

  def filter_title_eq(v)
    s(:eq, s(:id, :title), s(:value, v))
  end

  def execute_query(tree)
    relation = ::Book.all
    @joins.each do |association_name|
      relation = relation.joins(association_name)
    end
    visitor = ::AdvancedSearch::Adapters::PG::Visitor.new(:question_marks)
    tree.accept(visitor)
    query = visitor.result
    sql = [relation.to_sql, query.body].join(' where ')
    ::Book.find_by_sql([sql, *query.params])
  end
end
