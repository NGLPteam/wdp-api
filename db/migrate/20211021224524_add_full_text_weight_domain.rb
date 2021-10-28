class AddFullTextWeightDomain < ActiveRecord::Migration[6.1]
  def up
    execute <<~SQL
    CREATE DOMAIN full_text_weight AS "char"
      DEFAULT 'D'
      CONSTRAINT valid_full_text_weight CHECK (VALUE IN ('A', 'B', 'C', 'D'));
    SQL
  end

  def down
    execute <<~SQL
    DROP DOMAIN full_text_weight;
    SQL
  end
end
