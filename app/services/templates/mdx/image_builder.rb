# frozen_string_literal: true

module Templates
  module MDX
    # @see Templates::MDX::BuildImage
    class ImageBuilder < ::Templates::MDX::AbstractBuilder
      tag_name "MeruImage"

      option :src, Types::String

      option :alt, Types::String.optional, optional: true

      option :caption, Types::String.optional, optional: true

      option :height, Types::Coercible::String.optional, optional: true

      option :width, Types::Coercible::String.optional, optional: true

      def build_attributes
        super.merge(src:, alt:, caption:, height:, width:).compact_blank
      end

      def build_inner_html
        src
      end
    end
  end
end
