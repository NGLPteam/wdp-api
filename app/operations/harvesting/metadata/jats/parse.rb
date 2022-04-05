# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      # @see Harvesting::Metadata::JATS::Parsed
      class Parse
        include Dry::Monads[:do, :result]

        # @param [String] raw_metadata_source
        # @return [Dry::Monads::Success(Harvesting::Metadata::JATS::Parsed)]
        def call(raw_metadata_source)
          parsed = Harvesting::Metadata::JATS::Parsed.new raw_metadata_source

          Success parsed
        end
      end
    end
  end
end
