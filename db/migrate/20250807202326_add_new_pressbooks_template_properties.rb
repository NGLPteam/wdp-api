# frozen_string_literal: true

class AddNewPressbooksTemplateProperties < ActiveRecord::Migration[7.2]
  SELECTABLE_TEMPLATE_TABLES = %i[
    templates_descendant_list_definitions
    templates_link_list_definitions
    templates_list_item_definitions
  ].freeze

  def change
    reversible do |dir|
      dir.up do
        execute <<~SQL
        ALTER TYPE detail_variant ADD VALUE IF NOT EXISTS 'columns';
        SQL
      end
    end

    SELECTABLE_TEMPLATE_TABLES.each do |table|
      change_table table do |t|
        t.boolean :selection_unbounded, null: false, default: false
      end
    end

    change_table :templates_hero_definitions do |t|
      t.boolean :hide_summary, null: false, default: false
    end

    change_table :templates_navigation_definitions do |t|
      t.boolean :hide_metadata, null: false, default: false
    end
  end
end
