# frozen_string_literal: true

class AddFinalRoundTemplateProperties < ActiveRecord::Migration[7.0]
  LIST_DEFINITIONS = %i[
    templates_descendant_list_definitions
    templates_link_list_definitions
  ].freeze

  def change
    LIST_DEFINITIONS.each do |table|
      change_table table do |t|
        t.enum :entity_context, enum_type: :list_entity_context, null: false, default: :none

        t.boolean :browse_style, null: false, default: false
      end
    end
  end
end
