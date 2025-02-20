# frozen_string_literal: true

module Types
  class AncestorStaticOrderingPathType < Types::BaseObject
    implements Types::OrderingPathType

    description <<~TEXT
    This represents an ordering path for core properties on an
    entity's ancestor.
    TEXT
  end
end
