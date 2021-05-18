class CreateCommunities < ActiveRecord::Migration[6.1]
  def change
    create_table :communities, id: :uuid do |t|
      t.citext :system_slug, null: false
      t.integer :position
      t.citext :name, null: false
      t.jsonb :logo_data
      t.jsonb :metadata

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index :position
      t.index :system_slug, unique: true
    end
  end
end
