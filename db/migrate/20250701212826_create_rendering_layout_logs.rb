# frozen_string_literal: true

class CreateRenderingLayoutLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :rendering_layout_logs, id: :uuid do |t|
      t.references :schema_version, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :entity, polymorphic: true, null: false, type: :uuid
      t.references :layout_definition, polymorphic: true, null: false, type: :uuid

      t.enum :layout_kind, enum_type: :layout_kind, null: false

      t.decimal :render_duration, null: false

      t.uuid :generation, null: false

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }
    end
  end
end
