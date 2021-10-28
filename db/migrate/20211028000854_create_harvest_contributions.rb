class CreateHarvestContributions < ActiveRecord::Migration[6.1]
  def change
    create_table :harvest_contributions, id: :uuid do |t|
      t.references :harvest_contributor, null: false, foreign_key: true, type: :uuid
      t.references :harvest_entity, null: false, foreign_key: true, type: :uuid

      t.citext :kind
      t.jsonb :metadata

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[harvest_contributor_id harvest_entity_id], unique: true, name: "index_harvest_contributions_uniqueness"
    end
  end
end
