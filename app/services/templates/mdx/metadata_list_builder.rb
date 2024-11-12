# frozen_string_literal: true

module Templates
  module MDX
    # @see Templates::MDX::BuildMetadataList
    class MetadataListBuilder < ::Templates::MDX::AbstractBuilder
      include Templates::MDX::ContentWrapper

      tag_name "MetadataList"
    end
  end
end
