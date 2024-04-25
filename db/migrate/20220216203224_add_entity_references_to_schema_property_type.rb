require_relative "./20220216150516_simplify_entity_orderable_properties.rb"

class AddEntityReferencesToSchemaPropertyType < ActiveRecord::Migration[6.1]
  PROP_TYPES = SimplifyEntityOrderableProperties::PROP_TYPES

  SCALAR_TYPES = %w[asset assets boolean contributor contributors date email float full_text integer markdown multiselect select string tags timestamp unknown url variable_date].freeze

  UP_TYPES = %w[group] + (SCALAR_TYPES | %w[entity entities]).sort

  DOWN_TYPES = %w[group] + SCALAR_TYPES

  DEPENDENTS = %w[schema_version_properties entity_orderable_properties].freeze

  def up
    prepare_to_adjust!

    migrate_types! down: false

    wrap_up!
  end

  def down
    prepare_to_adjust!

    migrate_types! down: true

    wrap_up!
  end

  private

  def prepare_to_adjust!
    drop_view :schema_definition_properties, materialized: true

    PROP_TYPES.each do |prop_type|
      execute "DROP FUNCTION IF EXISTS #{prop_type.generate_fn_signature} CASCADE"
    end
  end

  def migrate_types!(down: false)
    execute <<~SQL
    ALTER TYPE schema_property_type RENAME TO schema_property_type_old;
    SQL

    types = down ? DOWN_TYPES : UP_TYPES

    create_enum "schema_property_type", types

    DEPENDENTS.each do |dep|
      migrate_table! dep, down: down
    end

    execute <<~SQL
    DROP TYPE schema_property_type_old;
    SQL

    recreate_eop_functions!
  end

  def migrate_table!(table, column: "type", down: false)
    say_with_time "Removing any entity references from #{table}" do
      execute(<<~SQL).cmdtuples
      DELETE FROM #{table} WHERE #{column} IN ('entity', 'entities');
      SQL
    end if down

    say_with_time "Dropping unnecessary default" do
      execute <<~SQL
      ALTER TABLE #{table} ALTER COLUMN #{column} DROP DEFAULT;
      SQL
    end

    say_with_time "Migrating #{table}.#{column}" do
      execute(<<~SQL).cmdtuples
      ALTER TABLE #{table} ALTER COLUMN #{column} SET DATA TYPE schema_property_type USING #{column}::text::schema_property_type;
      SQL
    end
  end

  def recreate_eop_functions!
    PROP_TYPES.each do |prop_type|
      execute prop_type.create_generate_fn_expression
    end

    say_with_time "Ensure entity orderable properties' generated expressions still work" do
      execute(<<~SQL).cmdtuples
      UPDATE entity_orderable_properties SET raw_value = raw_value;
      SQL
    end
  end

  def wrap_up!
    recreate_schema_definition_properties!
  end

  def recreate_schema_definition_properties!
    create_view :schema_definition_properties, materialized: true

    change_table :schema_definition_properties do |t|
      t.index %i[schema_definition_id path type], name: "schema_definition_properties_pkey", unique: true
      t.index :current
      t.index :orderable
      t.index :versions, using: :gin
    end
  end
end
