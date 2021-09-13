# frozen_string_literal: true

module Types
  class EntityVisibilityType < Types::BaseEnum
    description "The level of visibility an entity can have"

    value "VISIBLE", value: "visible"
    value "HIDDEN", value: "hidden"
    value "LIMITED", value: "limited"
  end
end
