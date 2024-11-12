# frozen_string_literal: true

module Templates
  module Tags
    module Blocks
      # @abstract
      class AbstractBlock < Liquid::Block
        include Templates::Tags::Helpers
        include Templates::Tags::ArgParsing
      end
    end
  end
end
