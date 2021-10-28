class AddIdentifierToAssets < ActiveRecord::Migration[6.1]
  def change
    add_column :assets, :identifier, :text

    add_index :assets, %i[attachable_type attachable_id identifier], unique: true, where: %[identifier IS NOT NULL], name: "index_assets_uniqueness"
  end
end
