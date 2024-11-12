# frozen_string_literal: true

module Templates
  module MDX
    # @see Templates::MDX::BuildSidebarList
    class SidebarListBuilder < AbstractBuilder
      include Templates::MDX::ContentWrapper

      tag_name "SidebarList"
    end
  end
end
