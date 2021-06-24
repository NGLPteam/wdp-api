class RenameLogoDataInCommunities < ActiveRecord::Migration[6.1]
  def change
    rename_column :communities, :logo_data, :thumbnail_data
  end
end
