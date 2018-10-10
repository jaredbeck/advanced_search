require "advanced_search/adapters/activerecord/executor"

module AdvancedSearch
  module Adapters
    module ActiveRecord
      RSpec.describe Executor do
        describe '#execute' do
          it 'returns expected data' do
            ast = s(:and,
              s(:eq,
                s(:id, :name),
                s(:value, 'Vernor Vinge')
              )
            )
            executor = described_class.new(Author.all, ast)
            result = executor.execute
            expect(result).to be_a(::ActiveRecord::Relation)
            data = result.to_a
            expect(data.length).to eq(1)
            author = data.first
            expect(author.name).to eq('Vernor Vinge')
            expect(author.birth_date.to_s(:iso8601)).to eq('1944-10-02')
          end
        end
      end
    end
  end
end
