require "advanced_search/adapters/pg/executor"

module AdvancedSearch
  module Adapters
    module PG
      RSpec.describe Executor do
        describe '#execute' do
          it 'returns expected data' do
            ast = s(:and,
              s(:eq,
                s(:id, :name),
                s(:value, 'Vernor Vinge')
              )
            )
            connection = ::PG::Connection.open(dbname: 'advanced_search')
            executor = described_class.new(
              'select name, birth_date from authors',
              ast,
              connection
            )
            result = executor.execute
            expect(result).to be_a(::PG::Result)
            data = result.values
            expect(data.length).to eq(1)
            expect(data.first).to eq([
              'Vernor Vinge',
              '1944-10-02'
            ])
          end
        end
      end
    end
  end
end
