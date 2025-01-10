# frozen_string_literal: true

module Templates
  module MDX
    # @see Templates::MDX::BuildDotList
    class DotListBuilder < ::Templates::MDX::AbstractBuilder
      include Templates::MDX::ContentWrapper

      tag_name "DotList"
    end
  end
end
