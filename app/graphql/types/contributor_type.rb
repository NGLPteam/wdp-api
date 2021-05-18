# frozen_string_literal: true

module Types
  module ContributorType
    include Types::BaseInterface

    description "A contributor who has made a contribution"

    field :kind, Types::ContributorKindType, null: false

    field :identifier, String, null: false

    field :email, String, null: true
    field :prefix, String, null: true
    field :suffix, String, null: true
    field :bio, String, null: true
    field :url, String, null: true

    field :links, [Types::ContributorLinkType, { null: true }], null: false
    field :collection_contributions, Types::CollectionContributionType.connection_type, null: false
    field :item_contributions, Types::ItemContributionType.connection_type, null: false
  end
end
