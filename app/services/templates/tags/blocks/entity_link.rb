# frozen_string_literal: true

module Templates
  module Tags
    module Blocks
      # @see Templates::MDX::EntityLinkBuilder
      class EntityLink < AbstractBlock
        args! :source

        def render(context)
          entity = args.entity(:source, context)

          content = super

          call_operation!("templates.mdx.build_entity_link", entity:, content:)
        end
      end
    end
  end
end
