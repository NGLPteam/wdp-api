class CreateOrderingEntries < ActiveRecord::Migration[6.1]
  def up
    execute <<~SQL
    CREATE TABLE ordering_entries (
      id uuid DEFAULT gen_random_uuid() NOT NULL,
      ordering_id uuid REFERENCES orderings(id) NOT NULL,
      entity_id uuid NOT NULL,
      entity_type text NOT NULL,
      position bigint NOT NULL,
      "link_operator" public."link_operator",
      auth_path public.ltree NOT NULL,
      scope public.ltree NOT NULL,
      relative_depth int NOT NULL,
      created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
      updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,

      PRIMARY KEY(ordering_id, id)
    ) PARTITION BY hash(ordering_id);
    SQL

    0.upto(7) do |i|
      part_name = "ordering_entries_part_#{i + 1}"

      execute(<<~SQL)
      CREATE TABLE #{part_name} PARTITION OF ordering_entries
      FOR VALUES WITH (modulus 8, remainder #{i});
      SQL
    end

    change_table :ordering_entries do |t|
      t.index :ordering_id
      t.index %i[entity_type entity_id], name: "index_ordering_entries_references_entity"
      t.index %i[ordering_id entity_type entity_id], unique: true, name: "index_ordering_entries_uniqueness"
      t.index %i[ordering_id scope position], name: "index_ordering_entries_sorted_by_scope", using: :gist
      t.index %i[ordering_id position], name: "index_ordering_entries_sort"
    end
  end

  def down
    8.downto(1) do |num|
      part_name = :"ordering_entries_part_#{num}"

      drop_table part_name
    end

    drop_table :ordering_entries
  end
end
