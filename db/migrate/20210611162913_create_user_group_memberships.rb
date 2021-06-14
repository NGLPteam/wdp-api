class CreateUserGroupMemberships < ActiveRecord::Migration[6.1]
  def change
    create_table :user_group_memberships, id: :uuid do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :user_group, null: false, foreign_key: { on_delete: :cascade }, type: :uuid

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[user_id user_group_id], unique: true, name: "index_user_group_memberships_uniqueness"
    end
  end
end
