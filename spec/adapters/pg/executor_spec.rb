require "advanced_search/adapters/pg/executor"

module AdvancedSearch
  module Adapters
    module PG
      RSpec.describe Executor do
        context 'with a single eq' do
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

        context 'with an eq and a lt' do
          it 'returns expected data' do
            ast = s(:and,
              s(:eq,
                s(:id, :book_id),
                s(:value, 2) # Peter and Gerry, co-authors
              ),
              s(:lt,
                s(:id, :author_id),
                s(:value, 3) # Excludes Gerry, who is 3
              )
            )
            connection = ::PG::Connection.open(dbname: 'advanced_search')
            executor = described_class.new(
              'select author_id, book_id from authorships',
              ast,
              connection
            )
            result = executor.execute
            expect(result).to be_a(::PG::Result)
            data = result.values
            expect(data.length).to eq(1)
            expect(data.first).to eq([
              '2', # author_id 2, Peter
              '2' # book_id 2, Home Tree Home
              # TODO: why are these coming back as strings?
            ])
          end
        end
      end
    end
  end
end
