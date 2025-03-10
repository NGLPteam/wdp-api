# frozen_string_literal: true

module Harvesting
  module Extraction
    module LiquidTags
      # @abstract
      class AbstractBlock < LiquidExt::Tags::AbstractBlock
        include Dry::Effects.Reader(:render_context)
        include Dry::Effects.State(:render_data)
      end
    end
  end
end
