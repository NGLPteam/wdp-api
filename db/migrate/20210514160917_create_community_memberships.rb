class CreateCommunityMemberships < ActiveRecord::Migration[6.1]
  def change
    create_table :community_memberships, id: :uuid do |t|
      t.references :community, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :role, null: true, foreign_key: { on_delete: :restrict }, type: :uuid
      t.references :user, null: false, foreign_key: { on_delete: :cascade }, type: :uuid

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[community_id user_id], name: "index_community_memberships_uniqueness", unique: true
    end
  end
end
