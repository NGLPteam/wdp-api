# frozen_string_literal: true

class AddMainBlurbTemplateTables < ActiveRecord::Migration[7.0]
  def change
    create_template_tables_for! template_kind: :blurb, layout_kind: :main
  end

  private

  def create_template_tables_for!(template_kind:, layout_kind:)
    layout_definition = :"layouts_#{layout_kind}_definitions"
    layout_instance = :"layouts_#{layout_kind}_instances"

    definition_name = :"templates_#{template_kind}_definitions"

    instance_name = :"templates_#{template_kind}_instances"

    create_table definition_name, id: :uuid do |t|
      t.references :layout_definition, type: :uuid, null: false, foreign_key: { on_delete: :cascade, to_table: layout_definition }, index: { name: "idx_#{definition_name}_layout" }

      t.enum :layout_kind, enum_type: "layout_kind", null: false, default: layout_kind
      t.enum :template_kind, enum_type: "template_kind", null: false, default: template_kind
      t.enum :background, enum_type: "blurb_background", null: false, default: "none"
      t.enum :width, enum_type: :template_width, null: false, default: "full"

      t.bigint :position, null: false

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.jsonb :config, null: false, default: {}
      t.jsonb :slots, null: false, default: {}

      t.index :position
    end

    create_table instance_name, id: :uuid do |t|
      t.references :layout_instance, type: :uuid, null: false, foreign_key: { on_delete: :cascade, to_table: layout_instance }, index: { name: "idx_#{instance_name}_layout" }
      t.references :template_definition, type: :uuid, null: false, foreign_key: { on_delete: :cascade, to_table: definition_name }, index: { name: "idx_#{instance_name}_defn" }
      t.references :entity, polymorphic: true, type: :uuid, null: false

      t.enum :layout_kind, enum_type: "layout_kind", null: false, default: layout_kind
      t.enum :template_kind, enum_type: "template_kind", null: false, default: template_kind

      t.uuid :generation, null: false

      t.bigint :position, null: false

      t.timestamp :last_rendered_at
      t.decimal :render_duration

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.jsonb :config, null: false, default: {}
      t.jsonb :slots, null: false, default: {}

      t.index :generation
      t.index :position
      t.index :last_rendered_at
    end
  end
end
