class AddTreeFieldsToOrderingEntries < ActiveRecord::Migration[6.1]
  def change
    change_table :ordering_entries do |t|
      t.timestamp :stale_at
      t.bigint :tree_depth
      t.uuid :tree_parent_id
      t.text :tree_parent_type

      t.index %i[ordering_id stale_at], name: "index_ordering_entries_staleness", where: %[stale_at IS NOT NULL]
      t.index %i[ordering_id tree_parent_id tree_parent_type], name: "index_ordering_entries_tree_parent"
    end
  end
end
