class RenameVersionPropertiesToConfiguration < ActiveRecord::Migration[6.1]
  def change
    rename_column :schema_versions, :properties, :configuration
  end
end
