class CreateRelatedCollectionLinks < ActiveRecord::Migration[6.1]
  def change
    add_index :entity_links, %i[source_id target_id], name: "index_entity_links_related_collections",
      where: %[source_type = 'Collection' AND target_type = 'Collection']

    add_index :collections, %i[id schema_version_id], name: "index_collections_related_by_schema"

    create_view :related_collection_links
  end
end
