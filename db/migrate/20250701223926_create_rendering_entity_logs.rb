# frozen_string_literal: true

class CreateRenderingEntityLogs < ActiveRecord::Migration[7.0]
  ENTITY_TABLES = %i[communities collections items].freeze

  def change
    ENTITY_TABLES.each do |table|
      change_table table do |t|
        t.uuid :generation

        t.decimal :render_duration

        t.timestamp :last_rendered_at
      end
    end

    create_table :rendering_entity_logs, id: :uuid do |t|
      t.references :schema_version, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :entity, polymorphic: true, null: false, type: :uuid

      t.decimal :render_duration, null: false

      t.uuid :generation, null: false

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }
    end
  end
end
