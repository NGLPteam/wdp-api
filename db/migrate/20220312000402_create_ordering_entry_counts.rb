class CreateOrderingEntryCounts < ActiveRecord::Migration[6.1]
  def change
    create_view :ordering_entry_counts, materialized: true

    change_table :ordering_entry_counts do |t|
      t.index %i[ordering_id], name: "ordering_entry_counts_pkey", unique: true
    end

    add_index :orderings, %i[id entity_id entity_type position name identifier],
      name: "index_orderings_for_initial",
      where: %[disabled_at IS NULL AND NOT hidden]
  end
end
