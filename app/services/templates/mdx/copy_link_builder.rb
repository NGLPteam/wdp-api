# frozen_string_literal: true

module Templates
  module MDX
    # @see Templates::MDX::BuildCopyLink
    class CopyLinkBuilder < ::Templates::MDX::AbstractBuilder
      tag_name "CopyLink"

      option :label, Templates::Types::String, default: proc { "Copy" }

      option :content, Templates::Types::String

      def build_attributes
        super.merge(label:)
      end

      def build_inner_html
        content.strip
      end
    end
  end
end
