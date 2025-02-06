# frozen_string_literal: true

module Types
  # @see Searching::Origin
  class SearchOriginTypeType < Types::BaseEnum
    description <<~TEXT
    The type of origin for this search scope.
    TEXT

    value "ENTITY", value: :entity
    value "GLOBAL", value: :global
    value "ORDERING", value: :ordering
    value "SCHEMA", value: :schema
  end
end
