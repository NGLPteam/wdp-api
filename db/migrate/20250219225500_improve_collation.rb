# frozen_string_literal: true

class ImproveCollation < ActiveRecord::Migration[7.0]
  def change
    add_numeric_collation!

    drop_dependent_views!

    change_title_collations!

    recreate_views!
  end

  private

  def drop_dependent_views!
    reversible do |dir|
      dir.up do
        drop_view :contributor_attributions, materialized: true
      end

      dir.down do
        recreate_contributor_attributions!
      end
    end

    drop_view :entity_descendants, revert_to_version: ?2
    drop_view :ordering_entry_candidates, revert_to_version: ?2
    drop_view :link_target_candidates, revert_to_version: ?1
  end

  def change_title_collations!
    set_column_collation! :entities, :title
    set_column_collation! :entity_hierarchies, :title
    set_column_collation! :communities, :title
    set_column_collation! :collections, :title
    set_column_collation! :items, :title
  end

  def recreate_views!
    create_view :entity_descendants, version: ?2
    create_view :link_target_candidates, version: ?1
    create_view :ordering_entry_candidates, version: ?2

    recreate_contributor_attributions!
  end

  def recreate_contributor_attributions!
    create_view :contributor_attributions, materialized: true, version: ?1

    change_table :contributor_attributions do |t|
      t.index :attribution_id, unique: true
      t.index %i[attribution_type attribution_id], name: "index_contributor_attributions_source"
      t.index %i[contributor_id published_rank], name: "index_contributor_published_ranking"
      t.index %i[contributor_id title_rank], name: "index_contributor_title_ranking"
      t.index %i[entity_type entity_id], name: "index_contributor_attributions_entity"
      t.index :item_id
    end
  end

  def add_numeric_collation!
    reversible do |dir|
      dir.up do
        execute(<<~SQL.strip_heredoc.strip)
        CREATE COLLATION custom_numeric (provider = icu, locale = 'en-u-kn-true');

        COMMENT ON COLLATION "custom_numeric" IS 'A custom collation that supports lexically ordering by integral values found within the string, so that 1, 2, 10 orders correctly.';
        SQL
      end

      dir.down do
        execute(<<~SQL.strip_heredoc.strip)
        DROP COLLATION "custom_numeric";
        SQL
      end
    end
  end

  def set_column_collation!(table, column)
    quoted_table = connection.quote_table_name table
    quoted_column = connection.quote_column_name column

    ident = "#{quoted_table}.#{quoted_column}"

    reversible do |dir|
      dir.up do
        say_with_time "Setting custom_numeric collation for #{ident}" do
          execute(<<~SQL.strip_heredoc.strip)
          ALTER TABLE #{quoted_table} ALTER COLUMN #{quoted_column} SET DATA TYPE citext COLLATE "custom_numeric";
          SQL
        end
      end

      dir.down do
        say_with_time "Setting default collation for #{ident}" do
          execute(<<~SQL.strip_heredoc.strip)
          ALTER TABLE #{quoted_table} ALTER COLUMN #{quoted_column} SET DATA TYPE citext;
          SQL
        end
      end
    end
  end
end
