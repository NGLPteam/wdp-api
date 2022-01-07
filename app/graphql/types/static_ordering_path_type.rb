# frozen_string_literal: true

module Types
  class StaticOrderingPathType < Types::BaseObject
    implements Types::OrderingPathType

    description <<~TEXT
    This property is static and is always available on an
    entity, irrespective of its schema.
    TEXT
  end
end
