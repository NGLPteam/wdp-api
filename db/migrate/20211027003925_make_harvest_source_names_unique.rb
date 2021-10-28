class MakeHarvestSourceNamesUnique < ActiveRecord::Migration[6.1]
  def change
    add_index :harvest_sources, :name, unique: true
  end
end
