# frozen_string_literal: true

module Harvesting
  module Utility
    class SanitizeBaseURL
      include Dry::Monads[:result, :do]

      # @param [Object] input
      # @return [Dry::Monads::Success(String)]
      # @return [Dry::Monads::Failure(:invalid_base_url, String)]
      def call(input)
        uri = yield parse input

        # Strip off the query. We never want it for the base_url.
        uri.query = nil

        Success uri.to_s
      end

      private

      # @param [Object] input
      # @return [Dry::Monads::Success(URI)]
      # @return [Dry::Monads::Failure(:invalid_base_url, String)]
      def parse(input)
        url = ::Harvesting::Types::URL[input]

        uri = URI(url)
      rescue ArgumentError, Dry::Types::ConstraintError, ::URI::Error => e
        Failure[:invalid_base_url, e.message]
      else
        Success uri
      end
    end
  end
end
