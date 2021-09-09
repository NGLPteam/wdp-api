# frozen_string_literal: true

module Mutations
  module Contracts
    class DestroyCollection < ApplicationContract
      json do
        required(:collection).filled(AppTypes.Instance(Collection))
      end

      rule(:collection) do
        key(:$global).failure(:destroy_collection_with_subcollections) if value.children.exists?
        key(:$global).failure(:destroy_collection_with_items) if value.items.exists?
      end
    end
  end
end
