# frozen_string_literal: true

module Types
  class OrderingDirectSelectionType < Types::BaseEnum
    value "NONE", value: "none"
    value "CHILDREN", value: "children"
    value "DESCENDANTS", value: "descendants"
  end
end
