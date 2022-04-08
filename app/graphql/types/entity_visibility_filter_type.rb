# frozen_string_literal: true

module Types
  # @see Entities::Types::Visibility
  class EntityVisibilityFilterType < Types::BaseEnum
    description <<~TEXT
    Filter entities by their visibility.

    `VISIBLE` is the default in most cases. Any other option requires special privileges.
    TEXT

    value "ALL", description: "Do not filter entities by their visibility at all.", value: :all
    value "VISIBLE", description: "Fetch only *currently visible* entities.", value: :visible
    value "HIDDEN", description: "Fetch only *currently hidden* entities.", value: :hidden
  end
end
