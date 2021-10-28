class RenameKindToProtocol < ActiveRecord::Migration[6.1]
  def change
    rename_column :harvest_sources, :kind, :protocol
  end
end
