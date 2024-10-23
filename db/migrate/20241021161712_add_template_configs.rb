# frozen_string_literal: true

class AddTemplateConfigs < ActiveRecord::Migration[7.0]
  TEMPLATE_KINDS = %w[
    contributor_list
    descendant_list
    detail
    hero
    link_list
    list_item
    metadata
    navigation
    ordering
    page_list
    supplementary
  ].freeze

  def change
    safe_create_enum :descendant_list_variant, %w[cards compact grid promos summary]
    safe_create_enum :descendant_list_selection_mode, %w[dynamic named manual]
    safe_create_enum :detail_variant, %w[full summary]
    safe_create_enum :link_list_selection_mode, %w[dynamic manual]
    safe_create_enum :link_list_variant, %w[cards compact grid promos summary]
    safe_create_enum :selection_source_mode, %w[self ancestor]

    TEMPLATE_KINDS.each do |template_kind|
      # list items don't get a background enum
      next if template_kind == "list_item"

      enum_type = :"#{template_kind}_background"

      safe_create_enum enum_type, %w[none light dark]

      change_table :"templates_#{template_kind}_definitions" do |t|
        t.enum :background, enum_type:, null: false, default: "none"
      end
    end

    change_table :templates_descendant_list_definitions do |t|
      t.enum :variant, enum_type: :descendant_list_variant, null: false, default: :cards
      t.enum :selection_source_mode, enum_type: :selection_source_mode, null: false, default: "self"
      t.enum :selection_mode, enum_type: :descendant_list_selection_mode, null: false, default: :manual

      t.text :selection_source, null: false, default: "self"
    end

    change_table :templates_detail_definitions do |t|
      t.enum :variant, enum_type: :detail_variant, null: false, default: :summary
    end

    change_table :templates_link_list_definitions do |t|
      t.enum :variant, enum_type: :link_list_variant, null: false, default: :cards
      t.enum :selection_source_mode, enum_type: :selection_source_mode, null: false, default: "self"
      t.enum :selection_mode, enum_type: :link_list_selection_mode, null: false, default: :manual

      t.text :selection_source, null: false, default: "self"
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
