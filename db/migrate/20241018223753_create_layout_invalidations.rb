# frozen_string_literal: true

class CreateLayoutInvalidations < ActiveRecord::Migration[7.0]
  def change
    create_table :layout_invalidations, id: :uuid do |t|
      t.references :entity, polymorphic: true, null: false, type: :uuid, index: false

      t.timestamp :stale_at, null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[entity_id stale_at], name: "index_layout_invalidations_distinct_staleness",
        order: { entity_id: :asc, stale_at: :desc }
    end
  end
end
