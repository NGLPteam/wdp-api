class AddInverseOrderToOrderingEntries < ActiveRecord::Migration[6.1]
  def change
    change_table :ordering_entries do |t|
      t.bigint :inverse_position, null: false

      t.index %i[ordering_id inverse_position], name: "index_ordering_entries_sort_inverse"
    end
  end
end
