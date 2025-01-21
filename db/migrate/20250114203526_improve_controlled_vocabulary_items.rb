# frozen_string_literal: true

class ImproveControlledVocabularyItems < ActiveRecord::Migration[7.0]
  def change
    change_table :controlled_vocabulary_items do |t|
      t.bigint :priority, null: false, default: 0
      t.bigint :ranking, null: true

      t.citext :tags, null: false, array: true, default: []

      t.index %i[priority position identifier], order: { priority: "DESC", position: :asc, identifier: :asc }, name: "index_controlled_vocabulary_items_sort_order"
      t.index %i[parent_id ranking position], name: "index_controlled_vocabulary_items_ranking"
      t.index :tags, using: :gin
    end

    reversible do |dir|
      dir.up do
        execute(<<~SQL)
        UPDATE controlled_vocabulary_items SET priority = 10000, tags = ARRAY['author'] WHERE identifier = 'aut';
        UPDATE controlled_vocabulary_items SET priority = 9000, tags = ARRAY['editor'] WHERE identifier = 'edt';
        UPDATE controlled_vocabulary_items SET priority = 8500, tags = ARRAY['translator'] WHERE identifier = 'trl';
        UPDATE controlled_vocabulary_items SET tags = ARRAY['affiliated_institution'] WHERE identifier = 'his';
        UPDATE controlled_vocabulary_items SET tags = ARRAY['contributor', 'default'] WHERE identifier = 'ctb';
        UPDATE controlled_vocabulary_items SET tags = ARRAY['advisor'] WHERE identifier = 'ths';
        UPDATE controlled_vocabulary_items SET priority = -10000, tags = ARRAY['other'] WHERE identifier = 'oth';
        SQL

        say_with_time "Calculate ranking for all items" do
          exec_update(<<~SQL.strip_heredoc)
          WITH rankings AS (
            SELECT
              id,
              dense_rank() OVER w AS ranking
              FROM controlled_vocabulary_items
              WINDOW w AS (
                PARTITION BY controlled_vocabulary_id, parent_id
                ORDER BY priority DESC NULLS LAST, position ASC, identifier ASC
              )
          )
          UPDATE controlled_vocabulary_items SET ranking = rankings.ranking
          FROM rankings WHERE rankings.id = controlled_vocabulary_items.id;
          SQL
        end
      end
    end
  end
end
