# frozen_string_literal: true

class CreateCollections < ActiveRecord::Migration[6.1]
  def change
    create_table :collections, id: :uuid do |t|
      t.references :community, null: false, foreign_key: { on_delete: :restrict }, type: :uuid
      t.references :schema_definition, null: false, foreign_key: { on_delete: :restrict }, type: :uuid
      t.references :parent, null: true, foreign_key: { to_table: :collections, on_delete: :restrict }, type: :uuid

      t.citext :identifier, null: false
      t.citext :system_slug, null: false

      t.citext :title
      t.citext :doi

      t.text :summary, null: false, default: ""

      t.jsonb :thumbnail_data
      t.jsonb :properties

      t.date :published_on
      t.timestamp :visible_after_at
      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index :doi, unique: true
      t.index :published_on
      t.index :visible_after_at
      t.index :properties, using: :gin
      t.index :system_slug, unique: true
    end
  end
end
