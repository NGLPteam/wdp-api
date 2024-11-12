# frozen_string_literal: true

module Templates
  module MDX
    # @see Templates::MDX::SidebarListBuilder
    class BuildSidebarList < Support::SimpleServiceOperation
      service_klass Templates::MDX::SidebarListBuilder
    end
  end
end
