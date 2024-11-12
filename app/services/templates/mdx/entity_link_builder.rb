# frozen_string_literal: true

module Templates
  module MDX
    # @see Templates::MDX::BuildEntityLink
    class EntityLinkBuilder < Templates::MDX::AbstractBuilder
      tag_name "EntityLink"

      option :entity, Templates::Types::Entity

      option :content, Templates::Types::String, default: proc { entity.title }

      delegate :schema_kind, :system_slug, to: :entity

      alias kind schema_kind
      alias slug system_slug

      def build_attributes
        super.merge(kind:, slug:)
      end

      def build_inner_html
        content.strip
      end
    end
  end
end
