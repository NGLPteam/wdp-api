# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::PreviewSlot
    # @see Mutations::Operations::PreviewSlot
    class PreviewSlot < MutationOperations::Contract
      json do
        required(:entity).value(:any_entity)
        required(:kind).value(:slot_kind)
        required(:raw_template).filled(:string)
      end
    end
  end
end
