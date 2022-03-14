class RemovePublishedOnFromEntities < ActiveRecord::Migration[6.1]
  def change
    remove_index :items, :published_on
    remove_index :collections, :published_on

    remove_column :items, :published_on, :date
    remove_column :collections, :published_on, :date
  end
end
