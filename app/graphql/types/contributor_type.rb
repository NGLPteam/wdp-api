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

    field :name, String, null: false,
      method: :safe_name,
      description: "A display name, independent of the type of contributor"

    field :image, Types::AssetPreviewType, null: true do
      description "An optional image associated with the contributor"
    end

    field :links, [Types::ContributorLinkType, { null: false }], null: false
    field :collection_contributions, resolver: Resolvers::CollectionContributionResolver, connection: true
    field :item_contributions, resolver: Resolvers::ItemContributionResolver, connection: true

    field :contribution_count, Integer, null: false,
      description: "The total number of contributions (item + collection) from this contributor"

    field :collection_contribution_count, Integer, null: false,
      description: "The total number of collection contributions from this contributor"

    field :item_contribution_count, Integer, null: false,
      description: "The total number of item contributions from this contributor"

    # @return [PreviewImages::TopLevelPreview]
    def image
      image_alt = "preview for contributor"

      PreviewImages::TopLevelPreview.new object.image_attacher, alt: image_alt
    end

    # @return [<Contributors::Link>]
    def links
      Array(object.links).compact
    end
  end
end
