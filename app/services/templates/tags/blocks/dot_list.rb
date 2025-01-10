# frozen_string_literal: true

module Templates
  module Tags
    module Blocks
      # @see Templates::MDX::DotListBuilder
      class DotList < AbstractBlock
        include Templates::Tags::Helpers

        def render(context)
          content = super

          call_operation!("templates.mdx.build_dot_list", content:)
        end
      end
    end
  end
end
