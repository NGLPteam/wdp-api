# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      class AbstractDrop < Harvesting::Metadata::JATS::AbstractJATSDrop
        include Harvesting::Metadata::Drops::HasContent

        private

        # @note We use nokogiri to pull out the entire tree as HTML
        #   since that's usually how we receive bodies.
        def extract_content
          metadata_context.abstract
        end
      end
    end
  end
end
