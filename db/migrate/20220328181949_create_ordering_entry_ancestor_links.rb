class CreateOrderingEntryAncestorLinks < ActiveRecord::Migration[6.1]
  def up
    execute <<~SQL
    CREATE INDEX index_ordering_entries_tree_ancestry_lookup ON ordering_entries USING GIST (ordering_id, auth_path, tree_depth) INCLUDE (id);

    CREATE INDEX index_ordering_entries_tree_child_lookup ON ordering_entries (ordering_id, auth_path) INCLUDE (tree_depth, id) WHERE tree_depth > 1;

    CREATE TABLE ordering_entry_ancestor_links (
      id uuid DEFAULT gen_random_uuid() NOT NULL,
      ordering_id uuid REFERENCES orderings(id) ON DELETE CASCADE NOT NULL,
      child_id uuid NOT NULL,
      ancestor_id uuid NOT NULL,
      inverse_depth bigint NOT NULL,
      created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
      updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,

      PRIMARY KEY (ordering_id, id),
      FOREIGN KEY (ordering_id, child_id) REFERENCES ordering_entries (ordering_id, id) ON DELETE CASCADE,
      FOREIGN KEY (ordering_id, ancestor_id) REFERENCES ordering_entries (ordering_id, id) ON DELETE CASCADE,
      CONSTRAINT oeal_child_does_not_parent_itself CHECK (child_id <> ancestor_id)
    ) PARTITION BY hash(ordering_id);
    SQL

    0.upto(7) do |i|
      part_name = "ordering_entry_ancestor_links_part_#{i + 1}"

      execute(<<~SQL)
      CREATE TABLE #{part_name} PARTITION OF ordering_entry_ancestor_links
      FOR VALUES WITH (modulus 8, remainder #{i});
      SQL
    end

    change_table :ordering_entry_ancestor_links do |t|
      t.index :ordering_id
      t.index :child_id
      t.index :ancestor_id
      t.index %i[ordering_id child_id inverse_depth], unique: true, name: "index_ordering_entry_ancestor_links_uniqueness"
      t.index %i[ordering_id child_id ancestor_id inverse_depth], order: { inverse_depth: :asc }, name: "index_ordering_entry_ancestor_links_sorting"
    end

    say_with_time "Populating ordering_entry_ancestor_links" do
      execute(<<~SQL).cmdtuples
      INSERT INTO ordering_entry_ancestor_links (ordering_id, child_id, ancestor_id, inverse_depth)
      SELECT oe.ordering_id, oe.id AS child_id, anc.id AS ancestor_id, oe.tree_depth - anc.tree_depth AS inverse_depth
      FROM ordering_entries oe
      INNER JOIN ordering_entries anc ON oe.ordering_id = anc.ordering_id AND oe.auth_path <@ anc.auth_path AND anc.tree_depth < oe.tree_depth
      WHERE oe.tree_depth > 1
      SQL
    end
  end

  def down
    8.downto(1) do |num|
      part_name = :"ordering_entry_ancestor_links_part_#{num}"

      drop_table part_name
    end

    drop_table :ordering_entry_ancestor_links

    execute <<~SQL
    DROP INDEX index_ordering_entries_tree_child_lookup;
    DROP INDEX index_ordering_entries_tree_ancestry_lookup;
    SQL
  end
end
