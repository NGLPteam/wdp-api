# frozen_string_literal: true

class CleanupDatabase < ActiveRecord::Migration[7.0]
  NEW_TABLES = %i[
    ordering_entries
    ordering_entry_ancestor_links
    ordering_entry_sibling_links
  ].freeze

  NEW_TABLES_AND_PARTITIONS = NEW_TABLES.flat_map do |table|
    [table].tap do |a|
      1.upto(8).each do |num|
        a << :"#{table}_part_#{num}"
      end
    end
  end.freeze

  OLD_TABLES = NEW_TABLES.index_with do |table|
    :"zz_#{table}"
  end.freeze

  OLD_TABLES_AND_PARTITIONS = NEW_TABLES_AND_PARTITIONS.index_with do |table|
    :"zz_#{table}"
  end.freeze

  def change
    set_up_schemas!

    drop_views!

    move_old_tables!

    create_new_unpartitioned_tables!

    restore_views!

    migrate_partitioned_data!
  end

  private

  def set_up_schemas!
    reversible do |dir|
      dir.up do
        execute <<~SQL
        DROP SCHEMA IF EXISTS heroku_ext;

        CREATE SCHEMA IF NOT EXISTS legacy;
        SQL
      end

      dir.down do
        execute <<~SQL
        DROP SCHEMA IF EXISTS legacy;
        SQL
      end
    end
  end

  def drop_views!
    drop_view :initial_ordering_derivations, revert_to_version: 1

    reversible do |dir|
      dir.down do
        change_table :ordering_entry_counts do |t|
          t.index %i[ordering_id], name: "ordering_entry_counts_pkey", unique: true
        end
      end
    end

    drop_view :ordering_entry_counts, materialized: true, revert_to_version: 1
  end

  def remove_old_foreign_keys!
    reversible do |dir|
      dir.up do
        execute <<~SQL
        ALTER TABLE ordering_entries DROP CONSTRAINT IF EXISTS ordering_entries_ordering_id_fkey;
        ALTER TABLE ordering_entry_ancestor_links DROP CONSTRAINT IF EXISTS ordering_entry_ancestor_links_ordering_id_fkey;
        ALTER TABLE ordering_entry_sibling_links DROP CONSTRAINT IF EXISTS ordering_entry_sibling_links_ordering_id_fkey;
        ALTER TABLE templates_ordering_instances DROP CONSTRAINT IF EXISTS ordering_instance_entry_fk;
        SQL
      end

      dir.down do
        execute <<~SQL
        ALTER TABLE "templates_ordering_instances" ADD CONSTRAINT "ordering_instance_entry_fk"
          FOREIGN KEY ("ordering_id", "ordering_entry_id") REFERENCES "ordering_entries" ("ordering_id", "id")
          ON DELETE SET NULL (ordering_entry_id)
          DEFERRABLE INITIALLY DEFERRED
        ;
        SQL
      end
    end
  end

  def move_old_tables!
    remove_old_foreign_keys!

    OLD_TABLES_AND_PARTITIONS.each do |old_name, new_name|
      rename_table old_name, new_name
    end

    reversible do |dir|
      dir.up do
        OLD_TABLES_AND_PARTITIONS.each_value do |table|
          execute <<~SQL
          ALTER TABLE public.#{table} SET SCHEMA legacy;
          SQL
        end
      end

      dir.down do
        OLD_TABLES_AND_PARTITIONS.each_value do |table|
          execute <<~SQL
          ALTER TABLE legacy.#{table} SET SCHEMA public;
          SQL
        end
      end
    end
  end

  def create_new_unpartitioned_tables!
    create_ordering_entries!

    create_ancestors!

    create_siblings!
  end

  def restore_views!
    create_view :ordering_entry_counts, materialized: true, version: 1

    change_table :ordering_entry_counts do |t|
      t.index %i[ordering_id], name: "ordering_entry_counts_pkey", unique: true
    end

    create_view :initial_ordering_derivations, version: 1
  end

  def create_ordering_entries!
    create_table :ordering_entries, id: :uuid do |t|
      t.references :ordering, type: :uuid, null: false, foreign_key: { on_delete: :cascade }, index: false
      t.references :entity, type: :uuid, null: false, polymorphic: true, index: { name: "index_ordering_entries_references_entity" }
      t.bigint :position, null: false
      t.bigint :inverse_position, null: false
      t.enum :link_operator, enum_type: "link_operator"
      t.column :auth_path, :ltree, null: false
      t.column :scope, :ltree, null: false
      t.integer :relative_depth, null: false
      t.bigint :tree_depth
      t.references :tree_parent, type: :uuid, null: true, polymorphic: true, index: false

      t.timestamp :stale_at, precision: 6
      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[ordering_id entity_type entity_id], unique: true, name: "index_ordering_entries_uniqueness"
      t.index %i[ordering_id position], name: "index_ordering_entries_sort"
      t.index %i[ordering_id inverse_position], name: "index_ordering_entries_sort_inverse"
      t.index %i[ordering_id scope position], name: "index_ordering_entries_sorted_by_scope", using: :gist
      t.index %i[ordering_id stale_at], name: "index_ordering_entries_staleness", where: %[stale_at IS NOT NULL]
      t.index %i[ordering_id tree_parent_id tree_parent_type], name: "index_ordering_entries_tree_parent"
    end

    reversible do |dir|
      dir.up do
        execute <<~SQL
        CREATE INDEX "index_ordering_entries_tree_ancestry_lookup" ON ordering_entries USING GIST (ordering_id, auth_path, tree_depth) INCLUDE (id);
        CREATE INDEX "index_ordering_entries_tree_child_lookup" ON ordering_entries (ordering_id, auth_path) INCLUDE (tree_depth, id) WHERE tree_depth > 1;
        SQL
      end
    end
  end

  def create_ancestors!
    create_table :ordering_entry_ancestor_links, id: :uuid do |t|
      t.references :ordering, type: :uuid, null: false, foreign_key: { on_delete: :cascade }
      t.references :child, type: :uuid, null: false, foreign_key: { to_table: :ordering_entries, on_delete: :cascade }
      t.references :ancestor, type: :uuid, null: false, foreign_key: { to_table: :ordering_entries, on_delete: :cascade }
      t.bigint :inverse_depth, null: false
      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.check_constraint <<~SQL.strip_heredoc.strip, name: "oeal_child_does_not_parent_itself"
      child_id <> ancestor_id
      SQL

      t.index %i[ordering_id child_id ancestor_id inverse_depth], name: "index_ordering_entry_ancestor_links_sorting"
      t.index %i[ordering_id child_id inverse_depth], unique: true, name: "index_ordering_entry_ancestor_links_uniqueness"
    end
  end

  def create_siblings!
    create_table :ordering_entry_sibling_links, id: :uuid do |t|
      t.references :ordering, type: :uuid, null: false, foreign_key: { on_delete: :cascade }
      t.references :sibling, type: :uuid, null: false, foreign_key: { to_table: :ordering_entries, on_delete: :cascade }
      t.references :prev, type: :uuid, null: true, foreign_key: { to_table: :ordering_entries, on_delete: :cascade }
      t.references :next, type: :uuid, null: true, foreign_key: { to_table: :ordering_entries, on_delete: :cascade }
      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.check_constraint <<~SQL.strip_heredoc.strip, name: "oesl_child_does_not_ref_itself"
      sibling_id <> prev_id AND sibling_id <> next_id
      SQL

      t.index %i[ordering_id sibling_id], unique: true, name: "index_ordering_entry_sibling_links_uniqueness"
    end
  end

  def migrate_partitioned_data!
    reversible do |dir|
      dir.up do
        say_with_time "Migrating ordering_entries" do
          exec_update(<<~SQL.strip_heredoc.strip)
          INSERT INTO ordering_entries (id, ordering_id, entity_id, entity_type, position, inverse_position, link_operator, auth_path, scope, relative_depth, tree_depth, tree_parent_id, tree_parent_type, stale_at, created_at, updated_at)
          SELECT id, ordering_id, entity_id, entity_type, position, inverse_position, link_operator, auth_path, scope, relative_depth, tree_depth, tree_parent_id, tree_parent_type, stale_at, created_at, updated_at FROM legacy.zz_ordering_entries;
          SQL
        end

        say_with_time "Migrating ordering_entry_ancestor_links" do
          exec_update(<<~SQL.strip_heredoc.strip)
          INSERT INTO ordering_entry_ancestor_links (id, ordering_id, child_id, ancestor_id, inverse_depth, created_at, updated_at)
          SELECT id, ordering_id, child_id, ancestor_id, inverse_depth, created_at, updated_at FROM legacy.zz_ordering_entry_ancestor_links;
          SQL
        end

        say_with_time "Migrating ordering_entry_sibling_links" do
          exec_update(<<~SQL.strip_heredoc.strip)
          INSERT INTO ordering_entry_sibling_links (ordering_id, sibling_id, prev_id, next_id, created_at, updated_at)
          SELECT ordering_id, sibling_id, prev_id, next_id, created_at, updated_at FROM legacy.zz_ordering_entry_sibling_links;
          SQL
        end

        say_with_time "restoring FK for ordering template instances" do
          execute <<~SQL
          ALTER TABLE "templates_ordering_instances" ADD CONSTRAINT "ordering_instance_entry_fk"
            FOREIGN KEY ("ordering_entry_id") REFERENCES "ordering_entries" ("id")
            ON DELETE SET NULL (ordering_entry_id)
            DEFERRABLE INITIALLY DEFERRED
          ;
          SQL
        end
      end
    end
  end
end
