# frozen_string_literal: true

class AddMarkedForPurge < ActiveRecord::Migration[7.0]
  def change
    change_table :communities do |t|
      t.boolean :marked_for_purge, null: false, default: false
    end

    change_table :collections do |t|
      t.boolean :marked_for_purge, null: false, default: false
    end

    change_table :items do |t|
      t.boolean :marked_for_purge, null: false, default: false
    end
  end
end
