# frozen_string_literal: true

module Templates
  module Tags
    module Blocks
      # @see Templates::MDX::SidebarItemBuilder
      class SidebarItem < AbstractBlock
        def render(context)
          content = super

          attrs = args.evaluate_many(:icon, :url, context:)

          call_operation!("templates.mdx.build_sidebar_item", content:, **attrs)
        end
      end
    end
  end
end
