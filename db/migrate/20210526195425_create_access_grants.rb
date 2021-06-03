class CreateAccessGrants < ActiveRecord::Migration[6.1]
  def change
    create_table :access_grants, id: :uuid do |t|
      t.references :accessible, polymorphic: true, null: false, type: :uuid
      t.references :role, null: false, foreign_key: { on_delete: :restrict }, type: :uuid
      t.references :user, null: false, foreign_key: { on_delete: :cascade }, type: :uuid

      t.ltree :auth_path, null: false
      t.column :auth_query, :lquery, null: false

      t.references :community, null: true, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :collection, null: true, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :item, null: true, foreign_key: { on_delete: :cascade }, type: :uuid

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[accessible_id accessible_type user_id], unique: true, name: "index_access_grants_uniqueness"
      t.index %i[accessible_id accessible_type role_id user_id], unique: true, name: "index_access_grants_role_check"
      t.index :auth_path, using: :gist
    end

    change_table :roles do |t|
      t.ltree :allowed_actions, array: true, null: false, default: []

      t.index :allowed_actions, using: :gist
    end
  end
end
