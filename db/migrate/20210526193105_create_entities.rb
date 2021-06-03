class CreateEntities < ActiveRecord::Migration[6.1]
  def change
    create_table :entities, id: :uuid do |t|
      t.references :hierarchical, polymorphic: true, null: false, type: :uuid, index: { unique: true }
      t.citext :system_slug, null: false
      t.ltree :auth_path, null: false
      t.ltree :role_prefix, null: false

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index :system_slug, unique: true

      t.index :auth_path, using: :gist
    end
  end
end
