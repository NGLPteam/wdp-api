class AddGeneratedColumnsToOrderings < ActiveRecord::Migration[6.1]
  def up
    execute <<~SQL
    ALTER TABLE orderings
      ADD COLUMN hidden boolean NOT NULL GENERATED ALWAYS AS (COALESCE(jsonb_to_boolean(definition -> 'hidden'), false)) STORED,
      ADD COLUMN constant boolean NOT NULL GENERATED ALWAYS AS (COALESCE(jsonb_to_boolean(definition -> 'constant'), false)) STORED,
      ADD COLUMN disabled boolean NOT NULL GENERATED ALWAYS AS (disabled_at IS NOT NULL) STORED,
      ADD CONSTRAINT enforce_ordering_identifier_parity CHECK (identifier = definition ->> 'id')
    ;
    SQL
  end

  def down
    execute <<~SQL
    ALTER TABLE orderings DROP CONSTRAINT enforce_ordering_identifier_parity;
    SQL

    remove_column :orderings, :disabled
    remove_column :orderings, :constant
    remove_column :orderings, :hidden
  end
end
