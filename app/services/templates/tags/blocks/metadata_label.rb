# frozen_string_literal: true

module Templates
  module Tags
    module Blocks
      # @see Templates::MDX::MetadataLabelBuilder
      class MetadataLabel < AbstractBlock
        def render(context)
          content = super

          call_operation!("templates.mdx.build_metadata_label", content:)
        end
      end
    end
  end
end
