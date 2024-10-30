# frozen_string_literal: true

class CreateTemplatesManualListEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :templates_manual_list_entries, id: :uuid do |t|
      t.references :source, polymorphic: true, null: false, type: :uuid
      t.references :target, polymorphic: true, null: false, type: :uuid

      t.enum :template_kind, null: false, enum_type: :template_kind

      t.text :list_name, null: false

      t.integer :position

      t.timestamps

      t.index %i[source_type source_id template_kind list_name position], name: "index_manual_template_references_ordering"
      t.index %i[source_type source_id target_type target_id template_kind list_name], unique: true, name: "index_manual_template_references_uniqueness"
    end
  end
end
