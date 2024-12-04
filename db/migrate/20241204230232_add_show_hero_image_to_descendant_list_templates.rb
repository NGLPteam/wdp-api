# frozen_string_literal: true

class AddShowHeroImageToDescendantListTemplates < ActiveRecord::Migration[7.0]
  def change
    change_table :templates_descendant_list_definitions do |t|
      t.boolean :show_hero_image, null: false, default: false
      t.boolean :use_selection_fallback, null: false, default: false
      t.enum :selection_fallback_mode, enum_type: :descendant_list_selection_mode, null: false, default: :manual
    end

    change_table :templates_link_list_definitions do |t|
      t.boolean :show_hero_image, null: false, default: false
      t.boolean :use_selection_fallback, null: false, default: false
      t.enum :selection_fallback_mode, enum_type: :link_list_selection_mode, null: false, default: :manual
    end
  end
end
