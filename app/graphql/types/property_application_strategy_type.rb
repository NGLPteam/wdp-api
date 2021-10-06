# frozen_string_literal: true

module Types
  class PropertyApplicationStrategyType < Types::BaseEnum
    description <<~TEXT.squish.strip_heredoc
    When altering a schema version for an entity, there are various strategies that
    can be used to determine how to handle the provided properties.
    TEXT

    value "APPLY", value: :apply, description: "If set to this value, property values will be validated and applied"

    value "SKIP", value: :skip,
      description: "If set to this value, property values will not be applied, and the entity will likely exist in an invalid state."
  end
end
