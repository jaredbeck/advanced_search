require 'set'

RSpec.describe LibraryCatalog do
  describe '#search' do
    context 'with a single eq' do
      it 'returns expected data' do
        params = { author_name_eq: 'Vernor Vinge' }
        catalog = described_class.new(params)
        books = catalog.search
        expect(books.length).to eq(1)
        book = books.first
        expect(book).to be_a(::Book)
        expect(book.title).to eq('A Deepness in the Sky')
        expect(book.authors.pluck(:name)).to eq(['Vernor Vinge'])
      end
    end
  end
end
