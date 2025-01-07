# frozen_string_literal: true

class RemovePartitionedTables < ActiveRecord::Migration[7.0]
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

  def up
    OLD_TABLES_AND_PARTITIONS.each_value.reverse_each do |table|
      execute <<~SQL.strip_heredoc
      DROP TABLE IF EXISTS legacy.#{table};
      SQL
    end

    execute <<~SQL
    DROP SCHEMA IF EXISTS legacy;
    SQL
  end

  def down
    # Intentionally left blank
  end
end
