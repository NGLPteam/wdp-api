# frozen_string_literal: true

module Mutations
  module Operations
    # @see Entities::PreviewSlot
    # @see Mutations::PreviewSlot
    class PreviewSlot
      include MutationOperations::Base

      use_contract! :preview_slot

      # @param [HierarchicalEntity] entity
      # @param [Templates::Types::SlotKind] kind
      # @param [String] raw_template
      # @return [void]
      def call(entity:, kind:, raw_template:, **)
        authorize entity, :update?

        preview = entity.preview_slot(raw_template:, kind:)

        slot = check_result! preview

        attach_many!(slot:)
      end
    end
  end
end
