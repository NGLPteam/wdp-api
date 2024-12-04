# frozen_string_literal: true

class AddTemplateWidth < ActiveRecord::Migration[7.0]
  TABLES = %i[
  templates_detail_definitions
  templates_descendant_list_definitions
  templates_link_list_definitions
  templates_page_list_definitions
  templates_contributor_list_definitions
  templates_ordering_definitions
  ].freeze

  def change
    create_enum :template_width, %w[full half]

    TABLES.each do |table_name|
      change_table table_name do |t|
        t.enum :width, enum_type: :template_width, null: false, default: "full"
      end
    end
  end
end
