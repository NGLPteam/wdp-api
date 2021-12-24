# frozen_string_literal: true

module Types
  # @note This interface exists to be able to DRY up adding timestamps
  #   to types that do not inherit from {Types::AbstractModelType}.
  module HasDefaultTimestamps
    include Types::BaseInterface

    description <<~TEXT
    Automatically-set timestamps present on most real models in the system.
    TEXT

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false,
      description: "The date this entity was added to the WDP"

    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false,
      description: "The date this entity was last updated within the WDP"
  end
end
