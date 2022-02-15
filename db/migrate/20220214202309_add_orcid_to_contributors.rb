class AddORCIDToContributors < ActiveRecord::Migration[6.1]
  def change
    change_table :contributors do |t|
      t.citext :orcid, null: true

      t.index :orcid, unique: true
    end
  end
end
