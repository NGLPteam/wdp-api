# frozen_string_literal: true

module Types
  # @see ReferencesNamedVariableDates
  module ReferencesGlobalEntityDatesType
    include Types::BaseInterface

    description <<~TEXT
    An interface for retrieving certain shared, common variable-precision dates
    that are associated with events in the publication, collection, and release
    of an entity.
    TEXT

    field :published, Types::VariablePrecisionDateType, null: false,
      description: "The date this entity was published"
  end
end
