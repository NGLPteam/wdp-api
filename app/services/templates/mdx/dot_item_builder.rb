# frozen_string_literal: true

module Templates
  module MDX
    # @see Templates::MDX::BuildDotItem
    class DotItemBuilder < ::Templates::MDX::AbstractBuilder
      include Templates::MDX::ContentWrapper

      tag_name "DotItem"
    end
  end
end
