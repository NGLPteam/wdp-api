# frozen_string_literal: true

module Harvesting
  module Extraction
    module LiquidTags
      class TagCaptor < Harvesting::Extraction::LiquidTags::AbstractBlock
        def render(context)
          raw_tag = super.to_s.strip.presence

          render_data[:tags] << raw_tag

          return ""
        end
      end
    end
  end
end
