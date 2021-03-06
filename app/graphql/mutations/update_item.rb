# frozen_string_literal: true

module Mutations
  class UpdateItem < Mutations::BaseMutation
    description "Update an item"

    field :item, Types::ItemType, null: true, description: "A new representation of the item, on a succesful update"

    argument :item_id, ID, loads: Types::ItemType, description: "The item to update", required: true

    include Mutations::Shared::UpdateHierarchicalEntityArguments
    include Mutations::Shared::AcceptsDOIInput

    performs_operation! "mutations.operations.update_item"
  end
end
