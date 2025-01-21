# frozen_string_literal: true

module Types
  # @see ItemAttribution
  class ItemAttributionType < Types::AbstractModel
    description <<~TEXT
    Attributions for items.
    TEXT

    implements Types::AttributionType
  end
end
