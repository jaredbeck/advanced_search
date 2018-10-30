require "advanced_search/adapters/pg/visitor"

module AdvancedSearch
  module Adapters
    module PG
      RSpec.describe Visitor do
        context 'with a single equality comparison' do
          it 'buidls the expected query' do
            ast = s(:eq, s(:id, :a), s(:value, 1))
            visitor = described_class.new(:question_marks)
            ast.accept(visitor)
            query = visitor.result
            expect(query.body).to eq('a = ?')
            expect(query.params).to eq([1])
          end
        end

        context 'with a conjunction of disjunctions' do
          it 'buidls the expected query' do
            ast = s(:and,
              s(:eq, s(:id, :a), s(:value, 1)),
              s(:or,
                s(:eq, s(:id, :b), s(:value, 2)),
                s(:lt, s(:id, :c), s(:value, 3))
              )
            )
            visitor = described_class.new(:dollars)
            ast.accept(visitor)
            query = visitor.result
            expect(query.body).to eq('( a = $1 and ( b = $2 or c < $3 ) )')
            expect(query.params).to eq([1, 2, 3])
          end
        end

        context 'with a disjunction of conjunctions' do
          it 'buidls the expected query' do
            ast = s(:or,
              s(:eq, s(:id, :a), s(:value, 1)),
              s(:and,
                s(:eq, s(:id, :b), s(:value, 2)),
                s(:lt, s(:id, :c), s(:value, 3))
              )
            )
            visitor = described_class.new(:dollars)
            ast.accept(visitor)
            query = visitor.result
            expect(query.body).to eq('( a = $1 or ( b = $2 and c < $3 ) )')
            expect(query.params).to eq([1, 2, 3])
          end
        end
      end
    end
  end
end
