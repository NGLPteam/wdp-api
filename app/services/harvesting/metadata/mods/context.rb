# frozen_string_literal: true

module Harvesting
  module Metadata
    module MODS
      class Context < Harvesting::Metadata::XMLContext
        after_initialize :parse_root!

        after_assigns :build_root_drop!

        # @return [Metadata::MODS::Root]
        attr_reader :root

        private

        # @return [void]
        def build_root_drop!
          @assigns[:mods] = @root.to_liquid
        end

        # @return [void]
        def parse_root!
          @root = ::Metadata::MODS::Root.from_xml(metadata_source)
        end
      end
    end
  end
end
