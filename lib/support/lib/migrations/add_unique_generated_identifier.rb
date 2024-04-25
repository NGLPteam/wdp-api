# frozen_string_literal: true

module Support
  module Migrations
    module AddUniqueGeneratedIdentifier
      extend ActiveSupport::Concern

      include Support::Migrations::Utility

      START_WITH = Support::Types::Integer.constrained(gt: 0)

      def add_unique_generated_identifier_for!(raw_table, start_with:, has_legacy_oz_identifier: true, column_name: :identifier, skip_column_add: false)
        table = table_ref raw_table

        identifier = column_ref column_name

        legacy_identifier = column_ref :legacy_oz_identifier

        sequence = identifier.with(prefix: raw_table, suffix: "seq")

        start_with = START_WITH[start_with]

        change_table table.to_sym do |t|
          t.bigint identifier.to_sym

          t.index identifier.to_sym, unique: true
        end unless skip_column_add

        reversible do |dir|
          dir.up do
            say_with_time "Add #{table}.#{identifier} sequence (#{sequence})" do
              execute <<~SQL
              CREATE SEQUENCE #{sequence}
              AS bigint
              INCREMENT BY 1
              START WITH #{connection.quote(start_with)}
              NO CYCLE
              OWNED BY #{table}.#{identifier};
              SQL
            end

            nextval = "nextval(#{sequence.value_quoted})"

            update_expr = has_legacy_oz_identifier ? "COALESCE(#{legacy_identifier}::bigint, #{nextval})" : nextval

            say_with_time "Migrating #{table} to have an identifier" do
              execute(<<~SQL).cmdtuples
              UPDATE #{table} SET #{identifier} = #{update_expr};
              SQL
            end

            say_with_time "Setting #{table} identifier default" do
              execute <<~SQL
              ALTER TABLE #{table}
                ALTER COLUMN #{identifier} SET DEFAULT #{nextval};
              SQL
            end
          end

          dir.down do
            execute <<~SQL
            ALTER TABLE #{table}
              ALTER COLUMN #{identifier} DROP DEFAULT;

            DROP SEQUENCE #{sequence};
            SQL
          end
        end

        change_column_null table.to_sym, identifier.to_sym, false
      end
    end
  end
end
