# frozen_string_literal: true

module Templates
  module MDX
    # @see Templates::MDX::SidebarItemBuilder
    class BuildSidebarItem < Support::SimpleServiceOperation
      service_klass Templates::MDX::SidebarItemBuilder
    end
  end
end
