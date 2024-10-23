# frozen_string_literal: true

class AddInitialTemplateProperties < ActiveRecord::Migration[7.0]
  def change
    change_table :templates_contributor_list_definitions do |t|
      t.integer :limit
    end

    change_table :templates_descendant_list_definitions do |t|
      t.text :title
      t.integer :selection_limit

      t.jsonb :dynamic_ordering_definition
      t.text :ordering_name

      t.text :see_all_button_label
      t.boolean :show_see_all_button, null: false, default: false
      t.boolean :show_entity_context, null: false, default: false
    end

    change_table :templates_detail_definitions do |t|
      t.boolean :show_announcements, null: false, default: false
      t.boolean :show_hero_image, null: false, default: false
    end

    change_table :templates_hero_definitions do |t|
      bools = %w[
        enable_descendant_browsing
        enable_descendant_search
        list_contributors
        show_basic_view_metrics
        show_big_search_prompt
        show_breadcrumbs
        show_doi
        show_hero_image
        show_issn
        show_sharing_link
        show_split_display
        show_thumbnail_image
      ]

      bools.each do |bool|
        t.boolean bool, null: false, default: false
      end

      t.text :descendant_search_prompt
    end

    change_table :templates_link_list_definitions do |t|
      t.text :title
      t.integer :selection_limit

      t.jsonb :dynamic_ordering_definition

      t.text :see_all_button_label
      t.boolean :show_see_all_button, null: false, default: false
      t.boolean :show_entity_context, null: false, default: false
    end
  end
end
