# frozen_string_literal: true

module Harvesting
  module Metadata
    module OAIDC
      class Context < Harvesting::Metadata::XMLContext
        after_initialize :parse_root!

        # @return [Metadata::OAIDC::Root]
        attr_reader :root

        private

        # @return [void]
        def parse_root!
          @root = ::Metadata::OAIDC::Root.from_xml(metadata_source)
        end
      end
    end
  end
end
