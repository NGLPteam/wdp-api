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
    field :orcid, String, null: true do
      description <<~TEXT
      An optional, unique [**O**pen **R**esearcher and **C**ontributor **ID**](https://orcid.org) associated with this contributor.
      TEXT
    end

    field :name, String, null: false,
      method: :safe_name,
      description: "A display name, independent of the type of contributor"

    image_attachment_field :image,
      description: "An optional image associated with the contributor."

    field :links, [Types::ContributorLinkType, { null: false }], null: false
    field :collection_contributions, resolver: Resolvers::CollectionContributionResolver, connection: true
    field :item_contributions, resolver: Resolvers::ItemContributionResolver, connection: true

    field :contribution_count, Integer, null: false,
      description: "The total number of contributions (item + collection) from this contributor"

    field :collection_contribution_count, Integer, null: false,
      description: "The total number of collection contributions from this contributor"

    field :item_contribution_count, Integer, null: false,
      description: "The total number of item contributions from this contributor"

    # @return [<Contributors::Link>]
    def links
      Array(object.links).compact
    end
  end
end
