class CreateRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :roles, id: :uuid do |t|
      t.citext :name, null: false
      t.citext :system_slug, null: false

      t.jsonb :access_control_list, null: false, default: {}

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index :system_slug, unique: true
    end
  end
end
