# frozen_string_literal: true

module Harvesting
  module Metadata
    module Actions
      # @abstract
      class ValidateRawMetadata
        # @param [String] raw_metadata
        # @return [Dry::Monads::Success(String)]
        def call(raw_metadata)
          # :nocov:
          Dry::Monads.Success(raw_metadata)
          # :nocov:
        end
      end
    end
  end
end
