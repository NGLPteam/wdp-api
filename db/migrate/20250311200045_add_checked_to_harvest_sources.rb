# frozen_string_literal: true

class AddCheckedToHarvestSources < ActiveRecord::Migration[7.0]
  def change
    create_enum :harvest_source_status, %w[active inactive]

    change_table :harvest_sources do |t|
      t.timestamp :checked_at

      t.enum :status, enum_type: :harvest_source_status, null: false, default: :inactive
    end
  end
end
