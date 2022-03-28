class CreateOrderingEntrySiblingLinks < ActiveRecord::Migration[6.1]
  def up
    execute <<~SQL
    CREATE TABLE ordering_entry_sibling_links (
      ordering_id uuid REFERENCES orderings(id) ON DELETE CASCADE NOT NULL,
      sibling_id uuid NOT NULL,
      prev_id uuid,
      next_id uuid,
      created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
      updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,

      PRIMARY KEY (ordering_id, sibling_id),
      FOREIGN KEY (ordering_id, sibling_id) REFERENCES ordering_entries (ordering_id, id) ON DELETE CASCADE,
      FOREIGN KEY (ordering_id, next_id) REFERENCES ordering_entries (ordering_id, id) ON DELETE CASCADE,
      FOREIGN KEY (ordering_id, prev_id) REFERENCES ordering_entries (ordering_id, id) ON DELETE CASCADE,
      CONSTRAINT oesl_child_does_not_ref_itself CHECK (sibling_id <> prev_id AND sibling_id <> next_id)
    ) PARTITION BY hash(ordering_id);
    SQL

    0.upto(7) do |i|
      part_name = "ordering_entry_sibling_links_part_#{i + 1}"

      execute(<<~SQL)
      CREATE TABLE #{part_name} PARTITION OF ordering_entry_sibling_links
      FOR VALUES WITH (modulus 8, remainder #{i});
      SQL
    end

    change_table :ordering_entry_sibling_links do |t|
      t.index :ordering_id
    end

    say_with_time "Populating ordering_entry_sibling_links" do
      execute(<<~SQL).cmdtuples
      INSERT INTO ordering_entry_sibling_links (ordering_id, sibling_id, prev_id, next_id)
      SELECT ordering_id, id AS sibling_id, lag(id) OVER w AS prev_id, lead(id) OVER w AS next_id
      FROM ordering_entries
      WINDOW w AS (PARTITION BY ordering_id ORDER BY position ASC)
      SQL
    end
  end

  def down
    8.downto(1) do |num|
      part_name = :"ordering_entry_sibling_links_part_#{num}"

      drop_table part_name
    end

    drop_table :ordering_entry_sibling_links
  end
end
