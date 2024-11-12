# frozen_string_literal: true

module Templates
  module Tags
    module Blocks
      # @see Templates::MDX::MetadataValueBuilder
      class MetadataValue < AbstractBlock
        args! :label

        def render(context)
          content = super

          tags = []

          label = args.evaluate(:label, context, allow_blank: true)

          if label
            tags << call_operation!("templates.mdx.build_metadata_label", content: label)
          end

          tags << call_operation!("templates.mdx.build_metadata_value", content:)

          tags.join("\n")
        end
      end
    end
  end
end
