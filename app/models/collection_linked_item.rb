# frozen_string_literal: true

class CollectionLinkedItem < ApplicationRecord
  pg_enum! :operator, as: :collection_linked_item_operator, _prefix: :operator

  belongs_to :source, class_name: "Collection", inverse_of: :collection_linked_items
  belongs_to :target, class_name: "Item", inverse_of: :collection_linked_items
end
