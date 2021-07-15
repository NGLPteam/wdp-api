class RenameNameToTitleInCommunities < ActiveRecord::Migration[6.1]
  def change
    rename_column :communities, :name, :title
  end
end
