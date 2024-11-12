# frozen_string_literal: true

module Templates
  module MDX
    # @see Templates::MDX::BuildMetadataValue
    class MetadataValueBuilder < ::Templates::MDX::AbstractBuilder
      include Templates::MDX::ContentWrapper

      tag_name "MetadataValue"
    end
  end
end
