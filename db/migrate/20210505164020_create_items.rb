# frozen_string_literal: true

class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items, id: :uuid do |t|
      t.references :collection, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.string :title, null: false
      t.string :description, null: false

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }
    end
  end
end
