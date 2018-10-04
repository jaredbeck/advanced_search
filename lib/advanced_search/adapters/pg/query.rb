module AdvancedSearch
  module Adapters
    module PG
      class Query
        def initialize(body, params)
          @body = body
          @params = params.to_a
        end

        attr_reader :body, :params
      end
    end
  end
end
