# frozen_string_literal: true

class AddMetadataFormatEnum < ActiveRecord::Migration[7.0]
  TABLES = %w[
    harvest_sources
    harvest_mappings
    harvest_attempts
    harvest_records
  ].freeze

  def change
    create_enum "harvest_metadata_format", %w[jats mets mods oaidc esploro]
  end

  private

  def migrate_table!(table)
    reversible do |dir|
      dir.up do
        say_with_time "Migrating data type for #{table}" do
          execute(<<~SQL)
          ALTER TABLE #{table}
            ALTER COLUMN metadata_format SET DATA TYPE "harvest_metadata_format" USING metadata_format::harvest_metadata_format;
          SQL
        end
      end

      dir.down do
        say_with_time "Reverting data type for #{table}" do
          execute(<<~SQL)
          ALTER TABLE #{table}
            ALTER COLUMN metadata_format SET DATA TYPE text USING metadata_format::text;
          SQL
        end
      end
    end
  end
end
