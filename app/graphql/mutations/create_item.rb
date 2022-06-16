# frozen_string_literal: true

module Mutations
  class CreateItem < Mutations::BaseMutation
    description "Create an item"

    field :item, Types::ItemType, null: true, description: "A representation of a successfully created item"

    argument :parent_id, ID, loads: Types::ItemParentType, required: true do
      description <<~TEXT
      The parent of the item. This can be the encoded ID of a collection or another item.
      TEXT
    end

    argument :schema_version_slug, String, required: false, transient: true, attribute: true, default_value: "default:item:latest"

    include Mutations::Shared::CreateHierarchicalEntityArguments
    include Mutations::Shared::AcceptsDOIInput

    performs_operation! "mutations.operations.create_item"
  end
end
