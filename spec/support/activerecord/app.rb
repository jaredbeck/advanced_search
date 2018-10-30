# An example ActiveRecord application.
require "active_record"
ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  host: 'localhost',
  database: 'advanced_search'
)
require_relative 'models/book'
require_relative 'models/authorship'
require_relative 'models/author'
require_relative 'searches/employee_phonebook'
require_relative 'searches/library_catalog'
