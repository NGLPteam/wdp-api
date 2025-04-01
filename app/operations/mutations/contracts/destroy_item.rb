# frozen_string_literal: true

module Mutations
  module Contracts
    class DestroyItem < ApplicationContract
      json do
        required(:item).filled(Support::GlobalTypes.Instance(Item))
      end

      rule(:item) do
        key(:$global).failure(:destroy_item_with_subitems) if value.children.exists?
      end
    end
  end
end
