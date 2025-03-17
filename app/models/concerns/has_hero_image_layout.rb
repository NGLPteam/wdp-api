# frozen_string_literal: true

module HasHeroImageLayout
  extend ActiveSupport::Concern

  # @api private
  HERO_IMAGE_VALUES = %i[one_column two_column].freeze

  # @api private
  HERO_IMAGE_MAPPING = HERO_IMAGE_VALUES.index_with(&:to_s).freeze

  included do
    enum :hero_image_layout, HERO_IMAGE_MAPPING, prefix: :with, suffix: :hero_image_layout
  end

  # @!attribute [rw] hero_image_layout
  # The layout to use when rendering a hero image.
  # @see Types::HeroImageLayoutType
  # @return ["one_column", "two_column"]

  # @!method with_one_column_hero_image_layout?
  # @return [Boolean]

  # @!method with_two_column_hero_image_layout?
  # @return [Boolean]

  # @!method with_one_column_hero_image_layout
  # @!scope class
  # @return [ActiveRecord::Relation<HasHeroImageLayout>]

  # @!method with_two_column_hero_image_layout
  # @!scope class
  # @return [ActiveRecord::Relation<HasHeroImageLayout>]
end
