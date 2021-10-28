class CreateSchematicTexts < ActiveRecord::Migration[6.1]
  def change
    create_table :schematic_texts, id: :uuid do |t|
      t.references :entity, polymorphic: true, null: false, type: :uuid

      t.citext :path, null: false

      t.citext :lang, null: true

      t.citext :kind, null: true, default: "text"

      t.column :dictionary, :regconfig, null: false, default: "simple"

      t.column :weight, :full_text_weight, null: false, default: ?D

      t.text :content, null: true

      t.text :text_content, null: true

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[entity_type entity_id path], unique: true, name: "index_schematic_texts_entity_path_uniqueness"
    end

    reversible do |dir|
      dir.up do
        execute(<<~SQL)
        ALTER TABLE schematic_texts
          ADD COLUMN document tsvector GENERATED ALWAYS AS (setweight(to_tsvector("dictionary", "text_content"), weight)) STORED;
        SQL
      end
    end

    change_table :schematic_texts do |t|
      t.index :document, using: :gin
    end
  end
end
