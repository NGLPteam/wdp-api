# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::RenderLayouts
    # @see Mutations::Operations::RenderLayouts
    class RenderLayouts < MutationOperations::Contract
      json do
        required(:entity).value(:any_entity)
      end
    end
  end
end
