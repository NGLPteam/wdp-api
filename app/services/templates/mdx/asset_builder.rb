# frozen_string_literal: true

module Templates
  module MDX
    # @see Templates::MDX::BuildAsset
    class AssetBuilder < Templates::MDX::AbstractBuilder
      tag_name "Asset"

      option :asset, Templates::Types::Asset

      option :content, Templates::Types::String, default: proc { asset.name }

      option :download, Templates::Types::Bool, default: proc { false }

      delegate :file_size, :system_slug, to: :asset

      alias slug system_slug
      alias size file_size

      def build_attributes
        kind = ::Types::AssetKindType.name_for_value(asset.kind)

        url = asset.download_url

        super.merge(
          kind:,
          size:,
          slug:,
          url:
        ).tap do |x|
          x.merge!(download:) if download
        end
      end

      def build_inner_html
        content.strip
      end
    end
  end
end
