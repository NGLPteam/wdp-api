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

    field :image, Types::AssetPreviewType, null: true do
      description "An optional image associated with the contributor"
    end

    field :links, [Types::ContributorLinkType, { null: true }], null: false
    field :collection_contributions, Types::CollectionContributionType.connection_type, null: false
    field :item_contributions, Types::ItemContributionType.connection_type, null: false

    # @return [PreviewImages::TopLevelPreview]
    def image
      image_alt = "preview for contributor"

      PreviewImages::TopLevelPreview.new object.image_attacher, alt: image_alt
    end
  end
end
