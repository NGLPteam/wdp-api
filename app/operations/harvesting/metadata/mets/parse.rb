# frozen_string_literal: true

module Harvesting
  module Metadata
    module METS
      # @see Harvesting::Metadata::METS::Parsed
      class Parse
        include Dry::Monads[:do, :result]

        # @param [String] raw_metadata_source
        # @return [Dry::Monads::Success(Harvesting::Metadata::METS::Parsed)]
        def call(raw_metadata_source)
          parsed = Harvesting::Metadata::METS::Parsed.new raw_metadata_source

          Success parsed
        end
      end
    end
  end
end
