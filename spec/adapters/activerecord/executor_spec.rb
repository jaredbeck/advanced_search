require "advanced_search/adapters/activerecord/executor"

module AdvancedSearch
  module Adapters
    module ActiveRecord
      RSpec.describe Executor do
        context 'with a single eq' do
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
            executor = described_class.new(Authorship.all, ast)
            result = executor.execute
            expect(result).to be_a(::ActiveRecord::Relation)
            data = result.to_a
            expect(data.length).to eq(1)
            authorship = data.first
            expect(authorship.book_id).to eq(2) # Home Tree Home
            expect(authorship.author_id).to eq(2) # Peter
          end
        end
      end
    end
  end
end
