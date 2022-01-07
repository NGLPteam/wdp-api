# frozen_string_literal: true

module Schemas
  module Orderings
    module PathOptions
      # Fetch an array of path option proxies for listing available paths in the API.
      #
      # @operation
      class Fetch
        include Dry::Monads[:try, :do, :result]

        # @return [Dry::Monads::Result]
        def call(**options)
          fetcher = yield initialize_fetcher(**options)

          fetcher.call
        end

        private

        def initialize_fetcher(**options)
          Try do
            Schemas::Orderings::PathOptions::Fetcher.new(**options)
          end.to_result
        end
      end
    end
  end
end
