# frozen_string_literal: true

module Types
  module AssetType
    include Types::BaseInterface

    description "A generic asset type, implemented by all the more specific kinds"

    field :attachable, Types::AnyAttachableType, null: false
    field :name, String, null: false
    field :caption, String, null: true
    field :kind, Types::AssetKindType, null: false
    field :file_size, Integer, null: false
    field :content_type, String, null: false
    field :preview, Types::AssetPreviewType, null: true
    field :download_url, String, null: true

    def alt_text
      object.alt_text.presence || object.name
    end

    def preview
      preview_alt = object.alt_text.presence || "preview for #{object.name}"

      PreviewImages::TopLevelPreview.new object.preview_attacher, alt: preview_alt
    end
  end
end
