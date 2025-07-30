# frozen_string_literal: true

module Harvesting
  module Metadata
    module Pressbooks
      class Context < Harvesting::Metadata::XMLContext
        after_initialize :parse_pressbooks!

        after_assigns :build_drops!

        # @return [Metadata::Pressbooks::Books::Record]
        attr_reader :pressbooks

        private

        # @return [void]
        def build_drops!
          @assigns[:pressbooks] = @pressbooks.to_liquid
        end

        # @return [void]
        def parse_pressbooks!
          @pressbooks = ::Metadata::Pressbooks::Books::Record.from_json(metadata_source)
        end
      end
    end
  end
end
