class CreateEntityComposedTexts < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        execute <<~SQL
        CREATE AGGREGATE tsvector_agg(tsvector) (
          STYPE = pg_catalog.tsvector,
          SFUNC = pg_catalog.tsvector_concat,
          INITCOND = ''
        );
        SQL
      end

      dir.down do
        execute <<~SQL
        DROP AGGREGATE tsvector_agg(tsvector);
        SQL
      end
    end

    create_table :entity_composed_texts, id: :uuid do |t|
      t.references :entity, null: false, polymorphic: true, type: :uuid, index: { name: "index_entity_composed_texts_uniqueness", unique: true }

      t.column :document, :tsvector, null: false, default: ""

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index :document, using: :gist
    end

    reversible do |dir|
      dir.up do
        execute <<~SQL
        ALTER TABLE entity_searchable_properties ALTER COLUMN entity_type SET DATA TYPE text;
        SQL

        say_with_time "Populating composed texts" do
          execute(<<~SQL).cmdtuples
          INSERT INTO entity_composed_texts (entity_type, entity_id, document)
          SELECT entity_type, entity_id, tsvector_agg(document) AS document
          FROM schematic_texts
          GROUP BY 1, 2
          SQL
        end
      end
    end
  end
end
