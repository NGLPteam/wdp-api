# frozen_string_literal: true

module Harvesting
  module Extraction
    module LiquidTags
      # @abstract
      class AbstractTag < LiquidExt::Tags::AbstractTag
        include Dry::Effects.Reader(:render_context)
        include Dry::Effects.State(:render_data)
      end
    end
  end
end
