# frozen_string_literal: true

class CreateHarvestMetadataMappings < ActiveRecord::Migration[7.0]
  def change
    create_enum :harvest_metadata_mapping_field, %w[relation title identifier]

    create_table :harvest_metadata_mappings, id: :uuid do |t|
      t.references :harvest_source, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :target_entity, polymorphic: true, null: false, type: :uuid

      t.enum :field, enum_type: :harvest_metadata_mapping_field, null: false

      t.citext :pattern, null: false

      t.timestamps

      t.index %i[harvest_source_id field pattern], unique: true, name: "index_harvest_metadata_mappings_uniqueness"
    end
  end
end
