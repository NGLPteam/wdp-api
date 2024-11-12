# frozen_string_literal: true

module Templates
  module MDX
    # @see Templates::MDX::BuildSidebarItem
    class SidebarItemBuilder < Templates::MDX::AbstractBuilder
      include Templates::MDX::ContentWrapper

      option :icon, Types::String.optional, optional: true

      option :url, Types::String.optional, optional: true

      tag_name "SidebarItem"

      def build_attributes
        super.merge(icon:, url:).compact_blank
      end
    end
  end
end
