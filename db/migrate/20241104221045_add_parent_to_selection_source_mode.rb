# frozen_string_literal: true

class AddParentToSelectionSourceMode < ActiveRecord::Migration[7.0]
  def up
    execute <<~SQL
    ALTER TYPE descendant_list_selection_mode ADD VALUE IF NOT EXISTS 'property';
    SQL

    execute <<~SQL
    ALTER TYPE selection_source_mode ADD VALUE IF NOT EXISTS 'parent';
    SQL
  end

  def down
    # Intentionally left blank.
  end
end
