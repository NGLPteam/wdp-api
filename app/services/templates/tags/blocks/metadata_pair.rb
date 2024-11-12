# frozen_string_literal: true

module Templates
  module Tags
    module Blocks
      # @see Templates::MDX::MetadataLabelBuilder
      # @see Templates::MDX::MetadataValueBuilder
      class MetadataPair < AbstractBlock
        args! :label

        def initialize(tag_name, markup, tokens)
          super

          unless args.has?(:label)
            raise Liquid::SyntaxError, "Expected #{markup.inspect} to include a label"
          end
        end

        def render(context)
          content = super

          tags = []

          label = args.evaluate(:label, context)

          tags << call_operation!("templates.mdx.build_metadata_label", content: label)

          tags << call_operation!("templates.mdx.build_metadata_value", content:)

          tags.join("\n")
        end
      end
    end
  end
end
