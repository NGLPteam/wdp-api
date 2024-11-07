# frozen_string_literal: true

class CreateTemplatesManualLists < ActiveRecord::Migration[7.0]
  TABLES = %i[
    templates_descendant_list_definitions
    templates_link_list_definitions
  ].freeze

  def change
    rename_column :templates_descendant_list_definitions, :ordering_name, :ordering_identifier

    TABLES.each do |table|
      change_table table do |t|
        t.text :manual_list_name, null: false, default: "manual"
        t.text :selection_source_ancestor_name

        if table.match?(/descendant/)
          t.text :selection_property_path
        end
      end
    end

    change_table :templates_ordering_definitions do |t|
      t.enum :ordering_source_mode, enum_type: :selection_source_mode, null: false, default: "parent"

      t.text :ordering_source, null: false, default: "parent"

      t.text :ordering_source_ancestor_name

      t.enum :selection_source_mode, enum_type: :selection_source_mode, null: false, default: "self"

      t.text :selection_source, null: false, default: "self"

      t.text :selection_source_ancestor_name

      t.text :ordering_identifier
    end

    change_table :templates_ordering_instances do |t|
      t.references :ordering, type: :uuid, null: true, foreign_key: { on_delete: :nullify }
      t.references :ordering_entry, type: :uuid, null: true, foreign_key: false, index: false

      t.index %i[ordering_id ordering_entry_id], name: "index_templates_ordering_instances_entry"
    end

    reversible do |dir|
      dir.up do
        execute <<~SQL
        ALTER TABLE "templates_ordering_instances" ADD CONSTRAINT "ordering_instance_entry_fk"
          FOREIGN KEY ("ordering_id", "ordering_entry_id") REFERENCES "ordering_entries" ("ordering_id", "id")
          ON DELETE SET NULL (ordering_entry_id)
          DEFERRABLE INITIALLY DEFERRED
        ;
        SQL
      end

      dir.down do
        execute <<~SQL
        ALTER TABLE "templates_ordering_instances" DROP CONSTRAINT "ordering_instance_entry_fk";
        SQL
      end
    end

    create_table :templates_manual_lists, id: :uuid do |t|
      t.references :layout_definition, polymorphic: true, null: false, type: :uuid
      t.references :template_definition, polymorphic: true, null: false, type: :uuid, index: { unique: true }

      t.enum :layout_kind, null: false, enum_type: :layout_kind
      t.enum :template_kind, null: false, enum_type: :template_kind

      t.text :list_name, null: false

      t.timestamps
    end
  end
end
