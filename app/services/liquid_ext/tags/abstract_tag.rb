# frozen_string_literal: true

module LiquidExt
  module Tags
    # @abstract
    class AbstractTag < Liquid::Tag
      extend Dry::Core::ClassAttributes

      include LiquidExt::Tags::Helpers
      include LiquidExt::Tags::ArgParsing
    end
  end
end
