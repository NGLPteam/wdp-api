# frozen_string_literal: true

module Mutations
  # @see Mutations::Operations::RenderLayouts
  class RenderLayouts < Mutations::BaseMutation
    description <<~TEXT
    Force the layouts to render for a given `Entity`.
    TEXT

    field :entity, Types::AnyEntityType, null: true do
      description <<~TEXT
      The newly-rendered entity with its updated layouts, if successful.
      TEXT
    end

    argument :entity_id, ID, loads: Types::AnyEntityType, required: true do
      description <<~TEXT
      The entity to render layouts on.
      TEXT
    end

    performs_operation! "mutations.operations.render_layouts"
  end
end
