class AddIdentifierToHarvestSources < ActiveRecord::Migration[6.1]
  def change
    add_column :harvest_sources, :identifier, :citext

    reversible do |dir|
      dir.up do
        say_with_time "Set default harvest source identifiers" do
          execute(<<~SQL).cmdtuples
          UPDATE harvest_sources SET identifier = CASE name
          WHEN 'Journal of Political Ecology' THEN 'jpe'
          WHEN 'Lymphology' THEN 'lymph'
          WHEN 'Journal of Extension' THEN 'joe'
          WHEN 'Practical Assessment, Research, and Evaluation' THEN 'pare'
          WHEN 'Translat Library' THEN 'translatlib'
          WHEN 'New Orleans' THEN 'neworleans'
          WHEN 'Cornell DSpace' THEN 'cornell'
          WHEN 'SFU CJHE' THEN 'cjhe'
          WHEN 'UC Merced OAI Test' THEN 'merced'
          ELSE
            CAST(gen_random_uuid() AS text)
          END
          SQL
        end
      end
    end

    change_column_null :harvest_sources, :identifier, false

    add_index :harvest_sources, :identifier, unique: true
  end
end
