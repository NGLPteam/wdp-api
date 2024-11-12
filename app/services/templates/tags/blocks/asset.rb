# frozen_string_literal: true

module Templates
  module Tags
    module Blocks
      class Asset < AbstractBlock
        args! :source

        def render(context)
          asset = args.asset(:source, context, allow_blank: true)

          return if asset.blank?

          content = super

          call_operation!("templates.mdx.build_asset", asset:, content:)
        end
      end
    end
  end
end
