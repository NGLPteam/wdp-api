class CreateItemContributions < ActiveRecord::Migration[6.1]
  def change
    create_table :item_contributions, id: :uuid do |t|
      t.references :contributor, null: false, foreign_key: true, type: :uuid
      t.references :item, null: false, foreign_key: true, type: :uuid

      t.citext :kind
      t.jsonb :metadata

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[contributor_id item_id], unique: true, name: "index_item_contributions_uniqueness"
    end
  end
end
