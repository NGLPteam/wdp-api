# frozen_string_literal: true

module Types
  module AssetType
    include Types::BaseInterface
    include GraphQL::Types::Relay::NodeBehaviors
    include Types::Sluggable

    description "A generic asset type, implemented by all the more specific kinds"

    field :attachable, Types::AnyAttachableType, null: false
    field :name, String, null: false
    field :caption, String, null: true
    field :kind, Types::AssetKindType, null: false
    field :file_size, Integer, null: false
    field :content_type, String, null: false
    field :download_url, String, null: true
    image_attachment_field :preview
  end
end
