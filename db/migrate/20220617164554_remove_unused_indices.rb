class RemoveUnusedIndices < ActiveRecord::Migration[6.1]
  # Most of these are duplicates created by `t.references` or otherwise superseded by better indices.
  def change
    remove_index :access_grants, name: "index_access_grants_on_accessible", column: [:accessible_type, :accessible_id]
    remove_index :assets, name: "index_assets_on_parent_id", column: :parent_id
    remove_index :authorizing_entities, name: "index_authorizing_entities_on_auth_path_btree", column: :auth_path
    remove_index :collection_contributions, name: "index_collection_contributions_on_contributor_id", column: :contributor_id
    remove_index :collection_linked_items, name: "index_collection_linked_items_on_source_id", column: :source_id
    remove_index :collection_links, name: "index_collection_links_on_source_id", column: :source_id
    remove_index :collections, name: "index_collections_related_by_schema", column: [:id, :schema_version_id]
    remove_index :community_memberships, name: "index_community_memberships_on_community_id", column: :community_id
    remove_index :entities, column: %i[auth_path entity_id entity_type system_slug], name: "index_entities_crumb_target"
    remove_index :entities, :title
    remove_index :entity_links, name: "index_entity_links_on_source", column: [:source_type, :source_id]
    remove_index :entity_orderable_properties, name: "index_entity_orderable_properties_on_entity", column: [:entity_type, :entity_id]
    remove_index :entity_searchable_properties, name: "index_entity_searchable_properties_on_entity", column: [:entity_type, :entity_id]
    remove_index :harvest_contributions, name: "index_harvest_contributions_on_harvest_contributor_id", column: :harvest_contributor_id
    remove_index :harvest_contributors, name: "index_harvest_contributors_on_harvest_source_id", column: :harvest_source_id
    remove_index :harvest_entities, name: "index_harvest_entities_on_harvest_record_id", column: :harvest_record_id
    remove_index :harvest_mappings, name: "index_harvest_mappings_on_harvest_source_id", column: :harvest_source_id
    remove_index :harvest_records, name: "index_harvest_records_on_harvest_attempt_id", column: :harvest_attempt_id
    remove_index :harvest_sets, name: "index_harvest_sets_on_harvest_source_id", column: :harvest_source_id
    remove_index :item_contributions, name: "index_item_contributions_on_contributor_id", column: :contributor_id
    remove_index :item_links, name: "index_item_links_on_source_id", column: :source_id
    remove_index :items, name: "index_items_related_by_schema", column: [:id, :schema_version_id]
    remove_index :named_variable_dates, name: "index_named_variable_dates_on_entity", column: [:entity_type, :entity_id]
    remove_index :ordering_entries, column: :ordering_id
    remove_index :ordering_entry_ancestor_links, column: :ordering_id
    remove_index :ordering_entry_sibling_links, column: :ordering_id
    remove_index :orderings, name: "index_orderings_on_entity", column: [:entity_type, :entity_id]
    remove_index :pages, name: "index_pages_on_entity", column: [:entity_type, :entity_id]
    remove_index :role_permissions, name: "index_role_permissions_on_role_id", column: :role_id
    remove_index :schema_version_ancestors, name: "index_schema_version_ancestors_on_schema_version_id", column: :schema_version_id
    remove_index :schema_version_associations, name: "index_schema_version_associations_on_source_id", column: :source_id
    remove_index :schema_version_properties, name: "index_schema_version_properties_on_schema_version_id", column: :schema_version_id
    remove_index :schema_versions, name: "index_schema_versions_on_schema_definition_id", column: :schema_definition_id
    remove_index :schematic_collected_references, name: "index_schematic_collected_references_on_referrer", column: [:referrer_type, :referrer_id]
    remove_index :schematic_scalar_references, name: "index_schematic_scalar_references_on_referrer", column: [:referrer_type, :referrer_id]
    remove_index :schematic_texts, name: "index_schematic_texts_on_entity", column: [:entity_type, :entity_id]
    remove_index :user_group_memberships, name: "index_user_group_memberships_on_user_id", column: :user_id
  end
end
