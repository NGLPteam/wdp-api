# frozen_string_literal: true

class AddShowBodyToDetailDefinitions < ActiveRecord::Migration[7.0]
  def change
    change_table :templates_detail_definitions do |t|
      t.boolean :show_body, null: false, default: false
    end
  end
end
