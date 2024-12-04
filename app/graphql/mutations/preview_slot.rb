# frozen_string_literal: true

module Mutations
  # @see Mutations::Operations::PreviewSlot
  # @see Templates::Slots::Render
  class PreviewSlot < Mutations::BaseMutation
    description <<~TEXT
    Preview a slot for a given entity.
    TEXT

    field :slot, Types::TemplateSlotInstanceType, null: true do
      description <<~TEXT
      The rendered slot (if successful)
      TEXT
    end

    argument :entity_id, ID, loads: Types::AnyEntityType, required: true do
      description <<~TEXT
      The entity to update.
      TEXT
    end

    argument :kind, Types::TemplateSlotKindType, required: true do
      description <<~TEXT
      The kind of slot to render.
      TEXT
    end

    argument :template, String, required: true, as: :raw_template do
      description <<~TEXT
      The template to render.
      TEXT
    end

    performs_operation! "mutations.operations.preview_slot"
  end
end
