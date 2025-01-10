# frozen_string_literal: true

class AddNewProperties < ActiveRecord::Migration[7.0]
  LIST_DEFINITIONS = %i[
    templates_descendant_list_definitions
    templates_link_list_definitions
  ].freeze

  LIST_INSTANCES = %i[
    templates_descendant_list_instances
    templates_link_list_instances
  ].freeze

  def change
    LIST_DEFINITIONS.each do |table|
      change_table table do |t|
        t.text :see_all_ordering_identifier
        t.boolean :show_contributors, null: false, default: false
        t.boolean :show_nested_entities, null: false, default: false
      end
    end

    LIST_INSTANCES.each do |table|
      change_table table do |t|
        t.references :see_all_ordering, type: :uuid, null: true, foreign_key: { to_table: :orderings, on_delete: :nullify }, index: { name: "index_#{table}_see_all_ordering" }
      end
    end

    safe_create_enum :list_item_selection_mode, %w[dynamic named manual property]

    change_table :templates_list_item_definitions do |t|
      t.boolean :use_selection_fallback, null: false, default: false

      t.integer :selection_limit
      t.enum :selection_mode, enum_type: :list_item_selection_mode, null: false, default: :manual
      t.enum :selection_fallback_mode, enum_type: :list_item_selection_mode, null: false, default: :manual
      t.enum :selection_source_mode, enum_type: :selection_source_mode, null: false, default: "self"

      t.jsonb :dynamic_ordering_definition

      t.text :ordering_identifier
      t.text :selection_source, null: false, default: "self"
      t.text :manual_list_name, null: false, default: "manual"
      t.text :selection_source_ancestor_name
      t.text :selection_property_path
    end
  end

  private

  def safe_create_enum(name, ...)
    reversible do |dir|
      dir.down do
        execute(<<~SQL.strip_heredoc.strip)
        DROP TYPE IF EXISTS #{name};
        SQL
      end
    end

    create_enum(name, ...)
  end
end
