# frozen_string_literal: true

module Types
  # @see Community#hero_image_layout
  class HeroImageLayoutType < Types::BaseEnum
    description "The layout to use when rendering a Hero for an `Entity`."

    value "ONE_COLUMN", value: "one_column"
    value "TWO_COLUMN", value: "two_column"
  end
end
