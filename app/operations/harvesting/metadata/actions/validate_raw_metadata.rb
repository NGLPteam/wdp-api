# frozen_string_literal: true

module Harvesting
  module Metadata
    module Actions
      class ValidateRawMetadata
        # @param [String] raw_metadata
        # @return [Dry::Monads::Success(String)]
        def call(raw_metadata)
          Dry::Monads.Success(raw_metadata)
        end
      end
    end
  end
end
