# frozen_string_literal: true

# Column ended up not being used and causes problems in dumps that aren't worth fixing.
class RemoveSelfPath < ActiveRecord::Migration[7.0]
  def up
    execute <<~SQL
    ALTER TABLE permissions DROP COLUMN IF EXISTS self_path_old;
    ALTER TABLE permissions DROP COLUMN IF EXISTS self_path;
    SQL
  end

  def down
    # Intentionally left blank
  end
end
