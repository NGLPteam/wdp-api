# frozen_string_literal: true

module Templates
  module MDX
    # @see Templates::MDX::BuildMetadataItem
    class MetadataItemBuilder < ::Templates::MDX::AbstractBuilder
      include Templates::MDX::ContentWrapper

      display_checks_children true

      tag_name "MetadataItem"
    end
  end
end
