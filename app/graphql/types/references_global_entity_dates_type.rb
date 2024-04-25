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

    field :published, Types::VariablePrecisionDateType, null: false do
      description "The date this entity was published"
    end

    def load_named_variable_dates
      Support::Loaders::AssociationLoader.for(object.class, :named_variable_dates)
    end

    def published
      load_named_variable_dates.then do
        Promise.resolve object.published
      end.then do |value|
        VariablePrecisionDate.parse value
      end
    end
  end
end
