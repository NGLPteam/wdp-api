# frozen_string_literal: true

module Entities
  # @see Mutations::PreviewSlot
  # @see Templates::Slots::Render
  class PreviewSlot
    include Dry::Monads[:result, :do]

    include MeruAPI::Deps[
      render_slot: "templates.slots.render",
    ]

    # @param [HierarchicalEntity] entity
    # @param [Templates::Types::SlotKind] kind
    # @param [String] raw_template
    # @return [Dry::Monads::Success(Templates::Slots::Instances::Abstract)]
    def call(entity, kind:, raw_template:)
      assigns = yield entity.to_liquid_assigns

      slot = yield render_slot.call(raw_template, assigns:, force: true, kind:)

      Success slot
    end
  end
end
