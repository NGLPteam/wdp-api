# frozen_string_literal: true

module Harvesting
  module Metadata
    module OAIDC
      class Context < Harvesting::Metadata::XMLContext
        after_initialize :parse_root!

        after_assigns :build_root_drop!

        # @return [Metadata::OAIDC::Root]
        attr_reader :root

        private

        # @return [void]
        def build_root_drop!
          @assigns[:oaidc] = @root.to_liquid
        end

        # @return [void]
        def parse_root!
          @root = ::Metadata::OAIDC::Root.from_xml(metadata_source)
        end
      end
    end
  end
end
