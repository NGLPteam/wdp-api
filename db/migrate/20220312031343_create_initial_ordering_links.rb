class CreateInitialOrderingLinks < ActiveRecord::Migration[6.1]
  def change
    create_enum "initial_ordering_kind", %w[selected derived]

    create_table :initial_ordering_links, id: :uuid do |t|
      t.references :entity, polymorphic: true, null: false, type: :uuid, index: { unique: true }
      t.references :ordering, null: false, foreign_key: { on_delete: :cascade }, type: :uuid

      t.enum :kind, enum_type: "initial_ordering_kind", null: false

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }
    end

    reversible do |dir|
      dir.up do
        execute(<<~SQL)
        ALTER TABLE initial_ordering_links ALTER COLUMN entity_type SET DATA TYPE text;
        SQL

        say_with_time "Populate initial_ordering_links" do
          execute(<<~SQL).cmdtuples
          INSERT INTO initial_ordering_links (entity_type, entity_id, ordering_id, kind)
          SELECT entity_type, entity_id, COALESCE(selected.ordering_id, derived.ordering_id) AS ordering_id,
            CASE WHEN selected.ordering_id IS NOT NULL THEN 'selected'::initial_ordering_kind ELSE 'derived'::initial_ordering_kind END AS kind
          FROM initial_ordering_selections AS selected
          FULL OUTER JOIN initial_ordering_derivations AS derived USING (entity_type, entity_id)
          WHERE
            entity_type IS NOT NULL
            AND
            entity_id IS NOT NULL
            AND
            (selected.ordering_id IS NOT NULL OR derived.ordering_id IS NOT NULL)
          ;
          SQL
        end
      end
    end
  end
end
