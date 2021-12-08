class CreateRelatedItemLinks < ActiveRecord::Migration[6.1]
  def change
    add_index :entity_links, %i[source_id target_id], name: "index_entity_links_related_items",
      where: %[source_type = 'Item' AND target_type = 'Item']

    add_index :items, %i[id schema_version_id], name: "index_items_related_by_schema"

    create_view :related_item_links
  end
end
