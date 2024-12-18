# frozen_string_literal: true

module Templates
  module Tags
    module Blocks
      # @see Templates::MDX::CopyLinkBuilder
      class CopyLink < AbstractBlock
        args! :label

        def render(context)
          content = super

          return "" if content.blank?

          label = args.evaluate(:label, context, allow_blank: true)

          options = { label:, content:, }.compact_blank

          call_operation!("templates.mdx.build_copy_link", **options)
        end
      end
    end
  end
end
