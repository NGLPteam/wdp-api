# frozen_string_literal: true

class AddAllowInsecureToHarvestSources < ActiveRecord::Migration[7.0]
  def change
    change_table :harvest_sources do |t|
      t.boolean :allow_insecure, null: false, default: false
    end
  end
end
