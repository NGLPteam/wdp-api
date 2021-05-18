class CreateCollectionContributions < ActiveRecord::Migration[6.1]
  def change
    create_table :collection_contributions, id: :uuid do |t|
      t.references :contributor, null: false, foreign_key: true, type: :uuid
      t.references :collection, null: false, foreign_key: true, type: :uuid

      t.citext :kind
      t.jsonb :metadata

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[contributor_id collection_id], unique: true, name: "index_collection_contributions_uniqueness"
    end
  end
end
