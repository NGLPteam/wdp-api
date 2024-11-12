# frozen_string_literal: true

module Templates
  module Tags
    module Blocks
      # @see Templates::MDX::MetadataListBuilder
      class MetadataList < AbstractBlock
        include Templates::Tags::Helpers

        def render(context)
          content = super

          call_operation!("templates.mdx.build_metadata_list", content:)
        end
      end
    end
  end
end
