# frozen_string_literal: true

class CreateItemAttributions < ActiveRecord::Migration[7.0]
  def change
    create_table :item_attributions, id: :uuid do |t|
      t.references :item, type: :uuid, null: false, foreign_key: { on_delete: :cascade }, index: false
      t.references :contributor, type: :uuid, null: false, foreign_key: { on_delete: :cascade }, index: false
      t.bigint :position, null: false

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[item_id contributor_id], unique: true, name: "index_item_attributions_uniqueness"
      t.index %i[item_id position], name: "index_item_attributions_ordering"
    end

    reversible do |dir|
      dir.up do
        say_with_time "Populating initial item attributions" do
          exec_update(<<~SQL.strip_heredoc)
          WITH attributed AS (
            SELECT DISTINCT ON (cont.item_id, cont.contributor_id)
              cont.item_id,
              cont.contributor_id,
              dense_rank() OVER w AS position
            FROM item_contributions cont
            INNER JOIN controlled_vocabulary_items cvi ON cvi.id = cont.role_id
            INNER JOIN contributors cbtr ON cbtr.id = cont.contributor_id
            WINDOW w AS (
              PARTITION BY cont.item_id
              ORDER BY cvi.priority DESC NULLS LAST, cvi.position ASC, cvi.identifier ASC, cont.position ASC NULLS LAST, cbtr.sort_name ASC
            )
          )
          INSERT INTO item_attributions (item_id, contributor_id, position, created_at, updated_at)
          SELECT item_id, contributor_id, position, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
          FROM attributed
          ON CONFLICT (item_id, contributor_id) DO UPDATE SET
            position = EXCLUDED.position,
            updated_at =
              CASE
              WHEN item_attributions.position IS DISTINCT FROM EXCLUDED.position
              THEN excluded.updated_at
              ELSE item_attributions.updated_at
              END
          SQL
        end
      end
    end
  end
end
