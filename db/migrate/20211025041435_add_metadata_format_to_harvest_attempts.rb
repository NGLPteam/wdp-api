class AddMetadataFormatToHarvestAttempts < ActiveRecord::Migration[6.1]
  def change
    rename_column :harvest_sources, :source_format, :metadata_format

    change_table :harvest_mappings do |t|
      t.text :metadata_format, null: true
    end

    change_table :harvest_attempts do |t|
      t.text :metadata_format, null: true
    end

    reversible do |dir|
      dir.up do
        say_with_time "Setting metadata format for existing harvest mappings" do
          execute(<<~SQL).cmdtuples
          UPDATE harvest_mappings SET metadata_format = 'mods'
          SQL
        end
      end

      dir.up do
        say_with_time "Setting metadata format for existing harvest attempts" do
          execute(<<~SQL).cmdtuples
          UPDATE harvest_attempts SET metadata_format = 'mods'
          SQL
        end
      end
    end

    change_column_null :harvest_attempts, :metadata_format, false
    change_column_null :harvest_mappings, :metadata_format, false
  end
end
