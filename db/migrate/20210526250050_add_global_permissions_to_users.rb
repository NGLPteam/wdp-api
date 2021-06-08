class AddGlobalPermissionsToUsers < ActiveRecord::Migration[6.1]
  def change
    change_table :users do |t|
      t.jsonb :global_access_control_list, null: false, default: {}
      t.ltree :allowed_actions, null: false, array: true, default: []

      t.index :global_access_control_list, using: :gin
      t.index :allowed_actions, using: :gist
    end
  end
end
