# frozen_string_literal: true

class TightenUpHarvestSources < ActiveRecord::Migration[7.0]
  def up
    execute <<~SQL
    DROP INDEX IF EXISTS "index_harvest_sources_on_name";
    SQL

    execute <<~SQL
    UPDATE harvest_sources SET protocol = 'unknown' WHERE protocol <> 'oai';
    SQL

    execute <<~SQL
    ALTER TABLE harvest_sources
      ALTER COLUMN protocol SET DATA TYPE harvest_protocol USING protocol::harvest_protocol;
    SQL

    execute <<~SQL
    ALTER TABLE harvest_sources
      ALTER COLUMN protocol SET DEFAULT 'unknown'::harvest_protocol;
    SQL
  end

  def down
    execute <<~SQL
    ALTER TABLE harvest_sources
      ALTER COLUMN protocol DROP DEFAULT;
    SQL

    execute <<~SQL
    ALTER TABLE harvest_sources
      ALTER COLUMN protocol SET DATA TYPE text USING protocol::text;
    SQL
  end
end
