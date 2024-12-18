# frozen_string_literal: true

class CreateOrderingInvalidations < ActiveRecord::Migration[7.0]
  def change
    create_table :ordering_invalidations, id: :uuid do |t|
      t.references :ordering, null: false, foreign_key: { on_delete: :cascade }, type: :uuid, index: false
      t.timestamp :stale_at, null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[ordering_id stale_at], name: "index_ordering_invalidations_distinct_staleness",
        order: { ordering_id: :asc, stale_at: :desc }
    end
  end
end
