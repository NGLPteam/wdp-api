# frozen_string_literal: true

class CreateHarvestConfigurations < ActiveRecord::Migration[7.0]
  def change
    create_table :harvest_configurations, id: :uuid do |t|
      t.references :harvest_source, null: false, foreign_key: { on_delete: :cascade }, type: :uuid

      t.references :harvest_mapping, null: true, foreign_key: { on_delete: :nullify }, type: :uuid

      t.references :harvest_set, null: true, foreign_key: { on_delete: :nullify }, type: :uuid

      t.references :harvest_attempt, null: true, foreign_key: { on_delete: :nullify }, type: :uuid, index: { unique: true }

      t.references :target_entity, polymorphic: true, null: false, type: :uuid

      t.enum :metadata_format, enum_type: :harvest_metadata_format, null: false

      t.jsonb :list_options,    null: false, default: {}
      t.jsonb :read_options,    null: false, default: {}
      t.jsonb :format_options,  null: false, default: {}
      t.jsonb :mapping_options, null: false, default: {}

      t.text :extraction_mapping_template, null: false, default: ""

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }
    end

    change_table :harvest_records do |t|
      t.references :harvest_configuration, null: true, type: :uuid, foreign_key: { on_delete: :nullify }
    end
  end
end
