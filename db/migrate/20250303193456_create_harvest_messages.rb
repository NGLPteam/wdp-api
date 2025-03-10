# frozen_string_literal: true

class CreateHarvestMessages < ActiveRecord::Migration[7.0]
  def change
    create_enum "harvest_message_level", %w[fatal error warn info debug trace]

    create_table :harvest_messages, id: :uuid do |t|
      t.references :harvest_source, null: true, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :harvest_attempt, null: true, foreign_key: { on_delete: :nullify }, type: :uuid
      t.references :harvest_mapping, null: true, foreign_key: { on_delete: :nullify }, type: :uuid
      t.references :harvest_record, null: true, foreign_key: { on_delete: :nullify }, type: :uuid
      t.references :harvest_entity, null: true, foreign_key: { on_delete: :nullify }, type: :uuid

      t.timestamp :at, null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.enum :level, enum_type: "harvest_message_level", null: false, default: :debug

      t.text :message, null: false

      t.text :tags, null: false, array: true, default: []

      t.jsonb :metadata, null: false, default: {}

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }
    end
  end
end
