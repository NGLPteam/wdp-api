# frozen_string_literal: true

module Support
  module Migrations
    module AddSearchableColumns
      extend ActiveSupport::Concern

      include Support::Migrations::Utility

      VALID_WEIGHTS = %w[A B C D].freeze

      def add_searchable_column_v1(table, column, dmetaphone: true, tsearch: true, trigram: true, weight: nil)
        add_dmetaphone_tsvector_for(table, column, weight:) if dmetaphone
        add_tsearch_tsvector_for(table, column, weight:) if tsearch
        add_trigram_index_for(table, column) if trigram
      end

      def drop_searchable_column_v1(table, column, dmetaphone: true, tsearch: true, trigram: true)
        drop_dmetaphone_tsvector_for(table, column) if dmetaphone
        drop_tsearch_tsvector_for(table, column) if tsearch
        drop_trigram_index_for(table, column) if trigram
      end

      def add_dmetaphone_tsvector_for(table, column, weight: nil)
        table = table_ref table
        column = column_ref column

        dmetaphone = column.with(prefix: "tsv", suffix: "dmetaphone")

        expression = maybe_weight_tsvector(column, fn: "build_dmetaphone_tsvector", weight:)

        reversible do |dir|
          dir.up do
            say_with_time "Add dmetaphone tsvector column for #{table}.#{column}" do
              execute <<~SQL
              ALTER TABLE #{table}
                ADD COLUMN #{dmetaphone} tsvector NOT NULL GENERATED ALWAYS AS (#{expression}) STORED;
              ;
              SQL
            end
          end

          dir.down do
            remove_column table.to_sym, dmetaphone.to_sym
          end
        end

        change_table table.to_sym do |t|
          t.index dmetaphone.to_sym, using: :gin
        end
      end

      def drop_dmetaphone_tsvector_for(table, column)
        table = table_ref table
        column = column_ref column

        dmetaphone = column.with(prefix: "tsv", suffix: "dmetaphone")

        remove_column table.to_sym, dmetaphone.to_sym
      end

      def add_tsearch_tsvector_for(table, column, weight: nil)
        table = table_ref table
        column = column_ref column

        tsearch = column.with(prefix: "tsv", suffix: "tsearch")

        expression = maybe_weight_tsvector(column, fn: "build_tsearch_tsvector", weight:)

        reversible do |dir|
          dir.up do
            say_with_time "Add tsearch tsvector column for #{table}.#{column}" do
              execute <<~SQL
              ALTER TABLE #{table}
                ADD COLUMN #{tsearch} tsvector NOT NULL GENERATED ALWAYS AS (#{expression}) STORED;
              SQL
            end
          end

          dir.down do
            remove_column table.to_sym, tsearch.to_sym
          end
        end

        change_table table.to_sym do |t|
          t.index tsearch.to_sym, using: :gin
        end
      end

      def drop_tsearch_tsvector_for(table, column)
        table = table_ref table
        column = column_ref column

        tsearch = column.with(prefix: "tsv", suffix: "tsearch")

        remove_column table.to_sym, tsearch.to_sym
      end

      def add_trigram_index_for(table, column)
        table = table_ref table
        column = column_ref column

        idx = table.with(prefix: "index", suffix: "unaccented_#{column.unquoted}_trigram")

        reversible do |dir|
          dir.up do
            say_with_time "Creating unaccented trigram index for #{table}.#{column}" do
              execute <<~SQL
              CREATE INDEX #{idx} ON #{table} USING GIN ((immutable_unaccent(COALESCE(#{column}::text, ''))) gin_trgm_ops);
              SQL
            end
          end

          dir.down do
            say_with_time "Removing unaccented trigram index for #{table}.#{column}" do
              execute <<~SQL
              DROP INDEX #{idx};
              SQL
            end
          end
        end
      end

      def drop_trigram_index_for(table, column)
        table = table_ref table
        column = column_ref column

        idx = table.with(prefix: "index", suffix: "unaccented_#{column.unquoted}_trigram")

        execute <<~SQL
        DROP INDEX #{idx};
        SQL
      end

      def compose_search!(name, table, **weighted_columns)
        compose_tsearch_vectors!(name, table, **weighted_columns)

        compose_dmetaphone_vectors!(name, table, **weighted_columns)

        columns = weighted_columns.keys

        compose_trigram_columns! name, table, *columns
      end

      def compose_tsearch_vectors!(name, table, **weighted_columns)
        as = concat_columns_into_vectors(fn: "build_tsearch_tsvector", weighted_columns:)

        composite = :"#{name}_tsearch_cmp"

        change_table table do |t|
          t.virtual composite, as:, type: :tsvector, null: false, stored: true

          t.index composite, using: :gin
        end
      end

      def compose_dmetaphone_vectors!(name, table, **weighted_columns)
        as = concat_columns_into_vectors(fn: "build_dmetaphone_tsvector", weighted_columns:)

        composite = :"#{name}_dmetaphone_cmp"

        change_table table do |t|
          t.virtual composite, as:, type: :tsvector, null: false, stored: true

          t.index composite, using: :gin
        end
      end

      def compose_trigram_columns!(name, table, *columns)
        quoted_columns = columns.map do |c|
          ref = column_ref c

          Arel.sql ref.quoted
        end

        concat = Arel::Nodes::NamedFunction.new("concat_trgm", quoted_columns)

        composite = :"#{name}_trgm"

        change_table table do |t|
          t.virtual composite, as: concat.to_sql, type: :text, stored: true, null: false

          t.index composite, using: :gin, opclass: :gin_trgm_ops
        end
      end

      def concat_tsv_indices!(...)
        concat_dmetaphone_indices!(...)
        concat_tsearch_indices!(...)
        concat_trigram_indices!(...)
      end

      def concat_dmetaphone_indices!(table, *columns)
        add_concatenated_tsvector_index(table, *columns, prefix: "tsv", suffix: "dmetaphone")
      end

      def concat_tsearch_indices!(table, *columns)
        add_concatenated_tsvector_index(table, *columns, prefix: "tsv", suffix: "tsearch")
      end

      def concat_trigram_indices!(table, first, second, *extra)
        table = table_ref table

        columns = [first, second, *extra].map { |c| column_ref(c) }

        digest = digest_for table, "trigram", *columns

        idx = table_ref ["index", "trgm", digest.hexdigest].join(?_)

        reversible do |dir|
          dir.up do
            say_with_time "Creating composite coalesced trigram index for #{columns.map(&:unquoted).join(', ')} on #{table}" do
              joined = columns.map do |column|
                "COALESCE(#{table}.#{column}, '')"
              end.join(" || ' '::text || ")

              expression = "immutable_unaccent(#{joined})"

              execute <<~SQL
              CREATE INDEX #{idx} ON #{table} USING GIN (#{expression} gin_trgm_ops);
              SQL
            end
          end

          dir.down do
            execute <<~SQL.strip
            DROP INDEX #{idx};
            SQL
          end
        end
      end

      private

      def concat_columns_into_vectors(fn:, weighted_columns:)
        weighted_columns.map do |column, weight|
          maybe_weight_tsvector(column, fn:, weight:)
        end.join(" || ")
      end

      def add_concatenated_tsvector_index(table, first, second, *extra, suffix:, prefix: "tsv")
        columns = [first, second, *extra].map { |c| column_ref(c, prefix:, suffix:) }

        digest = digest_for table, *columns

        idx = table_ref ["index", prefix, digest.hexdigest].join(?_)

        table = table_ref table

        reversible do |dir|
          dir.up do
            say_with_time "Creating composite tsvector index for #{columns.map(&:unquoted).join(', ')} on #{table}" do
              joined = columns.map do |column|
                "#{table}.#{column}"
              end.join(" || ")

              expression = "(#{joined})"

              execute <<~SQL
              CREATE INDEX #{idx} ON #{table} USING GIN (#{expression});
              SQL
            end
          end

          dir.down do
            execute <<~SQL.strip
            DROP INDEX #{idx};
            SQL
          end
        end
      end

      # @param [Support::Migrations::ColumnRef] column
      # @param [String] fn
      # @param ["A", "B", "C", "D", nil] weight
      def maybe_weight_tsvector(column, fn:, weight:)
        expression = "#{fn}(#{column})"

        expression = "setweight(#{expression}, '#{weight}')" if weight.in?(VALID_WEIGHTS)

        return expression
      end
    end
  end
end
