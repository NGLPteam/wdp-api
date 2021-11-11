# frozen_string_literal: true

module Mutations
  module Contracts
    class CreateOrdering < ApplicationContract
      json do
        required(:entity).value(AppTypes.Instance(HierarchicalEntity))
        required(:identifier).filled("coercible.string")
      end

      rule(:identifier) do
        key.failure(:invalid_identifier) unless value.match?(Ordering::IDENTIFIER_FORMAT)
      end

      rule(:entity, :identifier) do
        key(:identifier).failure(:must_be_unique_identifier) if values[:entity].orderings.by_identifier(values[:identifier]).exists?
      end
    end
  end
end
