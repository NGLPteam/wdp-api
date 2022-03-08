class RebuildOrderableProperties < ActiveRecord::Migration[6.1]
  def up
    recreate_generated_columns!
  end

  def down
    recreate_generated_columns!
  end

  private

  def recreate_generated_columns!
    PROP_TYPES.each do |prop_type|
      execute prop_type.drop_column_expression

      execute prop_type.create_generate_fn_expression

      execute prop_type.add_column_expression

      change_table :entity_orderable_properties do |t|
        prop_type.indices.each do |(expr, options)|
          t.index expr, options
        end
      end
    end
  end

  class PropType
    LANG = "SQL".freeze

    include Dry::Initializer[undefined: false].define -> do
      param :local_type, Dry::Types["coercible.symbol"]
      param :pg_type, Dry::Types["coercible.symbol"], default: proc { local_type }

      option :custom_pg_type, Dry::Types["bool"], default: proc { false }
      option :pg_schema, Dry::Types["string"], default: proc { "public" }
      option :convert_fn, Dry::Types["string"], default: proc { "jsonb_to_#{pg_type}" }
      option :column_name, Dry::Types["coercible.symbol"], default: proc { :"#{local_type}_value" }
      option :generate_fn, Dry::Types["string"], default: proc { "generate_#{column_name}" }
    end

    def add_column_expression
      <<~SQL.strip_heredoc.squish
      ALTER TABLE entity_orderable_properties
        ADD COLUMN #{column_name} #{quoted_pg_type} GENERATED ALWAYS AS (#{generate_expression}) STORED;
      SQL
    end

    def drop_column_expression
      <<~SQL.strip_heredoc
      ALTER TABLE entity_orderable_properties
        DROP COLUMN IF EXISTS #{column_name};
      SQL
    end

    def generate_fn_signature()
      %[#{generate_fn}(schema_property_type, jsonb)]
    end

    def create_generate_fn_expression
      <<~SQL.strip_heredoc
      CREATE OR REPLACE FUNCTION #{generate_fn_signature} RETURNS #{quoted_pg_type} AS $$
      SELECT CASE WHEN $1 = #{quoted_type} THEN #{convert_fn}($2) ELSE NULL END;
      $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;
      SQL
    end

    def indices
      [
        build_index(index_name, "ASC NULLS LAST"),
        build_index(inverted_index_name, "DESC NULLS LAST"),
      ]
    end

    def quoted_type
      quote local_type
    end

    private

    def build_index(name, order, expression: index_expression)
      [
        expression,
        {
          name: name,
          order: {
            column_name => order
          }
        }
      ]
    end

    def generate_expression
      <<~SQL
      #{generate_fn}("type", "raw_value")
      SQL
    end

    def index_expression
      %I[entity_type entity_id path #{column_name}]
    end

    def index_name
      "index_eop_#{local_type}"
    end

    def inverted_index_name
      "index_eop_#{local_type}_inverted"
    end

    def quote(value)
      ApplicationRecord.connection.quote value
    end

    def quoted_pg_type
      if custom_pg_type
        sch = ApplicationRecord.connection.quote_schema_name pg_schema

        typ = ApplicationRecord.connection.quote_column_name pg_type

        "#{sch}.#{typ}"
      else
        pg_type
      end
    end
  end

  PROP_TYPES = [
    PropType.new(:boolean),
    PropType.new(:date),
    PropType.new(:email, :citext, custom_pg_type: true),
    PropType.new(:float, :numeric),
    PropType.new(:integer, :bigint),
    PropType.new(:string, :text),
    PropType.new(:timestamp, :timestamptz),
    PropType.new(:variable_date, :variable_precision_date, custom_pg_type: true),
  ]
end
