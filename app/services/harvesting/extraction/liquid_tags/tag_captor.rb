# frozen_string_literal: true

module Harvesting
  module Extraction
    module LiquidTags
      class TagCaptor < Harvesting::Extraction::LiquidTags::AbstractBlock
        def render(context)
          raw_tags = super.to_s.strip.split(?,).map(&:squish).compact_blank

          render_data[:tags].concat(raw_tags)

          return ""
        end
      end
    end
  end
end
