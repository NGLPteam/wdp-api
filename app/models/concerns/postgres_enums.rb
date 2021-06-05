# frozen_string_literal: true

module PostgresEnums
  extend ActiveSupport::Concern

  POSTGRES_ENUM_PATTERN = /
  (?<stmt>CREATE\s+TYPE\s+(?:"?(?<schema>\w+)"?\.)"?(?<enum>\S+)"?\s+AS\s+ENUM\s+\((?<values>[^)]+?)\))
  /xms.freeze

  class << self
    # @!scope private
    # @return [ActiveSupport:HashWithIndifferentAccess]
    def fetch_pg_enum_definitions
      schema = Rails.root.join("db/structure.sql").read

      results = schema.scan POSTGRES_ENUM_PATTERN

      results.map(&:first).each_with_object({}.with_indifferent_access) do |statement, defs|
        parsed = PgQuery.parse statement

        create_enum = parsed.tree.stmts[0].stmt.create_enum_stmt

        enum_name = create_enum.type_name[1].string.str

        values = create_enum.vals.map { |val| val.string.str }

        defs[enum_name] = values
      end
    end
  end

  module ClassMethods
    @@pg_enum_definitions = PostgresEnums.fetch_pg_enum_definitions.freeze

    # @return [void]
    def pg_enum!(attr_name, as:, **options)
      values = pg_enum_values(as).to_h { |v| [v, v] }

      enum options.merge attr_name => values
    end

    def pg_enum_definitions
      @@pg_enum_definitions
    end

    def pg_enum_values(enum_name)
      pg_enum_definitions.fetch(enum_name)
    end
  end
end
