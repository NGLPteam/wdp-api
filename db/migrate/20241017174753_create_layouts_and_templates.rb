# frozen_string_literal: true

class CreateLayoutsAndTemplates < ActiveRecord::Migration[7.0]
  LANG = "SQL"

  LAYOUT_KINDS = %w[
    hero
    list_item
    main
    navigation
    metadata
    supplementary
  ].freeze

  MAIN_TEMPLATE_KINDS = %w[
    detail
    descendant_list
    link_list
    page_list
    contributor_list
    ordering
  ].freeze

  TEMPLATE_KINDS = (LAYOUT_KINDS.without("main") + MAIN_TEMPLATE_KINDS).freeze

  DERIVED_TEMPLATE_KINDS = LAYOUT_KINDS.without("main").index_with { Array(_1) }.merge(
    main: MAIN_TEMPLATE_KINDS,
  ).with_indifferent_access.freeze

  def change
    LAYOUT_KINDS.each do |layout_kind|
      create_tables_for!(layout_kind:)
    end
  end

  private

  def create_tables_for!(layout_kind:)
    create_layout_tables_for!(layout_kind:)

    template_kinds = DERIVED_TEMPLATE_KINDS.fetch(layout_kind)

    template_kinds.each do |template_kind|
      create_template_tables_for!(layout_kind:, template_kind:)
    end
  end

  def create_layout_tables_for!(layout_kind:)
    definition_name = :"layouts_#{layout_kind}_definitions"

    instance_name = :"layouts_#{layout_kind}_instances"

    create_table definition_name, id: :uuid do |t|
      t.references :schema_version, type: :uuid, null: false, foreign_key: { on_delete: :cascade }, index: false
      t.references :entity, polymorphic: true, type: :uuid, null: true, index: false

      t.enum :layout_kind, enum_type: "layout_kind", null: false, default: layout_kind
      t.virtual :root, type: :boolean, null: false, stored: true, as: %[entity_type IS NULL AND entity_id IS NULL]
      t.virtual :leaf, type: :boolean, null: false, stored: true, as: %[entity_type IS NOT NULL AND entity_id IS NOT NULL]

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.jsonb :config, null: false, default: {}

      t.index %i[schema_version_id], name: "udx_#{definition_name}_root", where: %[entity_type IS NULL and entity_id IS NULL], unique: true
      t.index %i[schema_version_id entity_type entity_id], name: "udx_#{definition_name}_leaf", where: %[entity_type IS NOT NULL and entity_id IS NOT NULL], unique: true
    end

    create_table instance_name, id: :uuid do |t|
      t.references :layout_definition, type: :uuid, null: false, foreign_key: { on_delete: :cascade, to_table: definition_name }, index: { name: "idx_#{instance_name}_defn" }
      t.references :entity, polymorphic: true, type: :uuid, null: false, index: { unique: true }

      t.enum :layout_kind, enum_type: "layout_kind", null: false, default: layout_kind

      t.uuid :generation, null: false

      t.timestamp :last_rendered_at
      t.decimal :render_duration

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.jsonb :config, null: false, default: {}

      t.index :generation
      t.index :last_rendered_at
    end
  end

  def create_template_tables_for!(template_kind:, layout_kind:)
    layout_definition = :"layouts_#{layout_kind}_definitions"
    layout_instance = :"layouts_#{layout_kind}_instances"

    definition_name = :"templates_#{template_kind}_definitions"

    instance_name = :"templates_#{template_kind}_instances"

    create_table definition_name, id: :uuid do |t|
      t.references :layout_definition, type: :uuid, null: false, foreign_key: { on_delete: :cascade, to_table: layout_definition }, index: { name: "idx_#{definition_name}_layout" }

      t.enum :layout_kind, enum_type: "layout_kind", null: false, default: layout_kind
      t.enum :template_kind, enum_type: "template_kind", null: false, default: template_kind

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
