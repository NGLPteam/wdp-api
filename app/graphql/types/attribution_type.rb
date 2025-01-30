# frozen_string_literal: true

module Types
  # @see Attribution
  # @see Types::CollectionAttributionType
  # @see Types::ContributorAttributionType
  # @see Types::ItemAttributionType
  module AttributionType
    include Types::BaseInterface

    field :contributor, Types::ContributorBaseType, null: false

    field :roles, [Types::ControlledVocabularyItemType, { null: false }], null: false do
      description <<~TEXT
      A priority-ordered list of the roles the associated contributor had.
      TEXT
    end

    load_association! :contributor

    load_association! :roles
  end
end
