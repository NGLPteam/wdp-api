class CreateHarvestContributors < ActiveRecord::Migration[6.1]
  def change
    add_index :contributors, :identifier, unique: true

    add_index :contributors, :properties, using: :gin

    create_table :harvest_contributors, id: :uuid do |t|
      t.references :harvest_source, null: false, type: :uuid, foreign_key: { on_delete: :cascade }
      t.references :contributor, null: true, type: :uuid, foreign_key: { on_delete: :nullify }

      t.enum :kind, as: "contributor_kind", null: false

      t.citext :identifier, null: false

      t.citext :email
      t.text :prefix
      t.text :suffix
      t.text :bio
      t.text :url

      t.jsonb :properties
      t.jsonb :links

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[harvest_source_id identifier], unique: true, name: "index_harvest_contributors_uniqueness"
    end
  end
end
