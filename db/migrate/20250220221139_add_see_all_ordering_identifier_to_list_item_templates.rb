# frozen_string_literal: true

class AddSeeAllOrderingIdentifierToListItemTemplates < ActiveRecord::Migration[7.0]
  def change
    change_table :templates_list_item_definitions do |t|
      t.text :see_all_ordering_identifier
    end

    change_table :templates_list_item_instances do |t|
      t.references :see_all_ordering, type: :uuid, null: true, foreign_key: { to_table: :orderings, on_delete: :nullify }, index: { name: "index_list_item_templates_see_all_ordering" }
    end
  end
end
