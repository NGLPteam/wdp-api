# frozen_string_literal: true

module Types
  class NullOrderPriorityType < Types::BaseEnum
    description "The priority for NULL values when sorting"

    value "LAST", value: "last"
    value "FIRST", value: "first"
  end
end
