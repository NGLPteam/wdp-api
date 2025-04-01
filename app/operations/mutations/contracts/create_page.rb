# frozen_string_literal: true

module Mutations
  module Contracts
    class CreatePage < ApplicationContract
      json do
        required(:entity).value(Support::GlobalTypes.Instance(HierarchicalEntity))
        required(:slug).filled("coercible.string")
      end

      rule(:entity, :slug) do
        key(:slug).failure(:must_be_unique_slug) if values[:entity].pages.by_slug(values[:slug]).exists?
      end
    end
  end
end
