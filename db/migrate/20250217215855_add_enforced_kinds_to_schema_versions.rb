# frozen_string_literal: true

class AddEnforcedKindsToSchemaVersions < ActiveRecord::Migration[7.0]
  def change
    change_table :schema_versions do |t|
      t.enum :enforced_parent_kinds, enum_type: :schema_kind, array: true, null: false, default: %w[community collection item]
      t.enum :enforced_child_kinds, enum_type: :child_entity_kind, array: true, null: false, default: %w[collection item]
    end
  end
end
