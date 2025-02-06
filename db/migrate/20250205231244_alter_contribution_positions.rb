# frozen_string_literal: true

class AlterContributionPositions < ActiveRecord::Migration[7.0]
  TABLES = %i[
    collection_contributions
    item_contributions
  ].freeze

  def change
    TABLES.each do |table|
      change_table table do |t|
        t.rename :position, :inner_position
        t.bigint :outer_position
      end
    end

    reversible do |dir|
      dir.up do
        exec_update <<~SQL
        UPDATE controlled_vocabulary_items SET priority = 12000 WHERE identifier = 'edt';
        SQL
      end
    end
  end
end
