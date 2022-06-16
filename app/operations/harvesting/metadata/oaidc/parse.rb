# frozen_string_literal: true

module Harvesting
  module Metadata
    module OAIDC
      # @see Harvesting::Metadata::OAIDC::Parsed
      class Parse
        include Dry::Monads[:do, :result]

        # @param [String] raw_metadata_source
        # @return [Dry::Monads::Success(Harvesting::Metadata::OAIDC::Parsed)]
        def call(raw_metadata_source)
          parsed = Harvesting::Metadata::OAIDC::Parsed.new raw_metadata_source

          Success parsed
        end
      end
    end
  end
end
