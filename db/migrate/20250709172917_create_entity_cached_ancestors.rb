# frozen_string_literal: true

class CreateEntityCachedAncestors < ActiveRecord::Migration[7.0]
  def change
    create_view :entity_cached_ancestors, materialized: true

    reversible do |dir|
      dir.up do
        execute <<~SQL
        CREATE UNIQUE INDEX entity_cached_ancestors_pkey ON entity_cached_ancestors (entity_type, entity_id, name) INCLUDE (ancestor_type, ancestor_id);
        SQL
      end
    end

    change_table :entities do |t|
      t.index %i[auth_path schema_version_id link_operator], name: "index_entities_schematic_descendant_querying", using: :gist
    end
  end
end
