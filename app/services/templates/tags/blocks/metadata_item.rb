# frozen_string_literal: true

module Templates
  module Tags
    module Blocks
      # @see Templates::MDX::MetadataItemBuilder
      class MetadataItem < AbstractBlock
        def render(context)
          content = super

          call_operation!("templates.mdx.build_metadata_item", content:)
        end
      end
    end
  end
end
