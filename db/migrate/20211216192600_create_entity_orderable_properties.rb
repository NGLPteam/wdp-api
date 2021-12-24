class CreateEntityOrderableProperties < ActiveRecord::Migration[6.1]
  def change
    create_table :entity_orderable_properties, id: :uuid do |t|
      t.references :entity, polymorphic: true, null: false, type: :uuid
      t.references :schema_version_property, null: false, foreign_key: { on_delete: :restrict }, type: :uuid
      t.enum :type, as: "schema_property_type", null: false
      t.text :path, null: false
      t.bigint :fixed_position
      t.jsonb :raw_value

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[entity_type entity_id path], unique: true, name: "index_eop_uniqueness"
      t.index %i[entity_type entity_id path fixed_position], name: "index_eop_fixed_position"
      t.index %i[entity_type entity_id path fixed_position], name: "index_eop_fixed_position_inverted", order: { fixed_position: "DESC NULLS LAST" }
    end

    reversible do |dir|
      dir.up do
        execute <<~SQL
        ALTER TABLE entity_orderable_properties ALTER COLUMN entity_type SET DATA TYPE text;
        SQL

        PROP_TYPES.each do |prop_type|
          execute prop_type.add_column_expression

          change_table :entity_orderable_properties do |t|
            prop_type.indices.each do |(expr, options)|
              t.index expr, options
            end
          end
        end
      end
    end
  end

  class PropType
    include Dry::Initializer[undefined: false].define -> do
      param :local_type, Dry::Types["coercible.symbol"]
      param :pg_type, Dry::Types["coercible.symbol"], default: proc { local_type }

      option :convert_fn, Dry::Types["string"], default: proc { "jsonb_to_#{pg_type}" }
      option :column_name, Dry::Types["coercible.symbol"], default: proc { :"#{local_type}_value" }
    end

    def add_column_expression
      <<~SQL.strip_heredoc.squish
      ALTER TABLE entity_orderable_properties
        ADD COLUMN #{column_name} #{pg_type} GENERATED ALWAYS AS (#{generate_expression}) STORED;
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

    def index_where
      <<~SQL.strip_heredoc.squish
      type = #{quoted_type}
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

    def build_index(name, order, expression: index_expression, where: index_where)
      [
        expression,
        {
          name: name,
          order: {
            column_name => order
          },
          where: where
        }
      ]
    end

    def generate_expression
      <<~SQL
      CASE WHEN type = #{quoted_type} THEN #{convert_fn}(raw_value) ELSE NULL END
      SQL
    end

    def quote(value)
      ApplicationRecord.connection.quote value
    end
  end

  PROP_TYPES = [
    PropType.new(:boolean),
    PropType.new(:date),
    PropType.new(:email, :citext),
    PropType.new(:float, :numeric),
    PropType.new(:integer, :bigint),
    PropType.new(:string, :text),
    PropType.new(:timestamp, :timestamptz),
    PropType.new(:variable_date, :variable_precision_date),
  ]
end
