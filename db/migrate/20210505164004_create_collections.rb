# frozen_string_literal: true

class CreateCollections < ActiveRecord::Migration[6.1]
  def change
    create_table :collections, id: :uuid do |t|
      t.text :title, null: false
      t.text :description, null: false

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }
    end
  end
end
