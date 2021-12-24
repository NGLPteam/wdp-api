# frozen_string_literal: true

module Types
  class OrderingEntrySortModeType < Types::BaseEnum
    description "When fetching entries from an ordering, you can swap between the default or a special 'inverted' mode"

    value "DEFAULT", value: "default", description: "Retrieve the ordering entries as defined by default"
    value "INVERSE", value: "inverse", description: "Retrieve the ordering entries in an inverted order, accounting for paths"
  end
end
