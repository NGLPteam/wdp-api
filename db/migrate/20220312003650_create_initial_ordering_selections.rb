class CreateInitialOrderingSelections < ActiveRecord::Migration[6.1]
  def change
    create_table :initial_ordering_selections, id: :uuid do |t|
      t.references :entity, polymorphic: true, null: false, type: :uuid, index: { unique: true }
      t.references :ordering, null: false, foreign_key: { on_delete: :cascade }, type: :uuid

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }
    end
  end
end
