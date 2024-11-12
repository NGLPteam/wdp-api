# frozen_string_literal: true

module Templates
  module MDX
    # @see Templates::MDX::BuildMetadataLabel
    class MetadataLabelBuilder < ::Templates::MDX::AbstractBuilder
      include Templates::MDX::ContentWrapper

      tag_name "MetadataLabel"
    end
  end
end
