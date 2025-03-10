# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      class SelfUriDrop < Harvesting::Metadata::JATS::AbstractJATSDrop
        after_initialize :extract_props!

        # @return [String]
        attr_reader :content_type

        # @return [String]
        attr_reader :href

        # @return [String]
        attr_reader :id

        private

        # @return [void]
        def extract_props!
          @content_type = @data.content_type

          @href = @data.href

          @id = @data.id
        end
      end
    end
  end
end
