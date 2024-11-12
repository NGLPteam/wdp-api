# frozen_string_literal: true

module Templates
  module Tags
    module Flat
      # @abstract
      class AbstractTag < Liquid::Tag
        include Templates::Tags::Helpers
        include Templates::Tags::ArgParsing
      end
    end
  end
end
