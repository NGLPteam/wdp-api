# frozen_string_literal: true

module Templates
  module Tags
    module Blocks
      # @see Templates::MDX::DotItemBuilder
      class DotItem < AbstractBlock
        def render(context)
          content = super

          call_operation!("templates.mdx.build_dot_item", content:)
        end
      end
    end
  end
end
