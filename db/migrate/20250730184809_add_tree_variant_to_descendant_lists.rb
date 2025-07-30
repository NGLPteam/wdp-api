# frozen_string_literal: true

class AddTreeVariantToDescendantLists < ActiveRecord::Migration[7.0]
  def up
    execute <<~SQL
    ALTER TYPE descendant_list_variant ADD VALUE IF NOT EXISTS 'tree';
    ALTER TYPE link_list_variant ADD VALUE IF NOT EXISTS 'tree';
    SQL
  end

  def down
    # Intentionally left blank
  end
end
