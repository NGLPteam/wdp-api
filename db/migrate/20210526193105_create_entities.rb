class CreateEntities < ActiveRecord::Migration[6.1]
  def change
    enable_extension "btree_gist"

    create_table :entities, id: :uuid do |t|
      t.references :entity, polymorphic: true, null: false, type: :uuid, index: { unique: true }
      t.references :hierarchical, polymorphic: true, null: false, type: :uuid
      t.citext :system_slug, null: false
      t.ltree :auth_path, null: false
      t.ltree :scope, null: false

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index :system_slug, unique: true

      t.index :auth_path, using: :gist

      t.index %i[hierarchical_type hierarchical_id auth_path scope], using: :gist, name: "index_entities_permissions_calculation"
    end
  end
end
