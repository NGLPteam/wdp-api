# frozen_string_literal: true

module Types
  class EntityLinkOperatorType < Types::BaseEnum
    description "A link operator describes how a source is linked to its target"

    value "CONTAINS", value: "contains"
    value "REFERENCES", value: "references"
  end
end
