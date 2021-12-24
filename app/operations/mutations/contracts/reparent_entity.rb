# frozen_string_literal: true

module Mutations
  module Contracts
    # Validate the attempt to reparent a child entity.
    class ReparentEntity < MutationOperations::Contract
      json do
        required(:parent).filled(Schemas::Types::SchemaInstance)
        required(:child).filled(Schemas::Types::SchemaInstance)
      end

      rule(:parent, :child) do
        key(:child).failure(:cannot_parent_itself) if values[:parent] == values[:child]

        if has_default_edge? && default_edge.tree?
          key(:child).failure(:cannot_own_parent) if values[:parent].in?(values[:child].descendants)
        end
      end

      validate_association_between! :parent, :child
    end
  end
end
