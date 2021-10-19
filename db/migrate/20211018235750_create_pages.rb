class CreatePages < ActiveRecord::Migration[6.1]
  def change
    create_table :pages, id: :uuid do |t|
      t.references :entity, polymorphic: true, null: false, type: :uuid
      t.integer :position, null: false, default: 0
      t.citext :title, null: false
      t.citext :slug, null: false

      t.text :body, null: false

      t.jsonb :hero_image_data

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[entity_type entity_id slug], unique: true, name: "index_pages_uniqueness"
      t.index %i[entity_type entity_id position], name: "index_pages_ordering"
    end
  end
end
