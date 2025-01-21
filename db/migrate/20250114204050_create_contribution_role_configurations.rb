# frozen_string_literal: true

class CreateContributionRoleConfigurations < ActiveRecord::Migration[7.0]
  def change
    create_table :contribution_role_configurations, id: :uuid do |t|
      t.references :controlled_vocabulary, null: false, foreign_key: { on_delete: :restrict }, type: :uuid, index: { name: "index_contribution_role_configurations_vocabulary" }
      t.references :default_item, null: false, foreign_key: { to_table: :controlled_vocabulary_items, on_delete: :restrict }, type: :uuid
      t.references :other_item, null: true, foreign_key: { to_table: :controlled_vocabulary_items, on_delete: :restrict }, type: :uuid
      t.references :source, polymorphic: true, null: false, type: :uuid, index: { unique: true }

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }
    end

    reversible do |dir|
      dir.up do
        say_with_time "Ensuring a bare minimum MARC Relators contribution role" do
          exec_update(<<~SQL)
          INSERT INTO controlled_vocabularies (namespace, identifier, "version", provides, name)
          VALUES ('meru.host', 'marc_codes', '1.0.0', 'contribution_roles', 'MARC Relator Codes')
          ON CONFLICT DO NOTHING;
          SQL
        end

        say_with_time "Ensuring bare minimum MARC Relators items exist" do
          exec_update(<<~SQL)
          WITH default_vocab AS (
            SELECT "controlled_vocabularies"."id" AS controlled_vocabulary_id
            FROM "controlled_vocabularies"
            WHERE
              "controlled_vocabularies"."namespace" = 'meru.host'
              AND
              "controlled_vocabularies"."identifier" = 'marc_codes'
              AND
              "controlled_vocabularies"."version" = '1.0.0'
            LIMIT 1
          ), items AS (
            SELECT
              default_vocab.controlled_vocabulary_id, t.*
              FROM default_vocab
              CROSS JOIN (
                VALUES
                ('aut', 'Author', 10000, ARRAY['author']),
                ('edt', 'Editor', 9000, ARRAY['editor']),
                ('trl', 'Translator', 8500, ARRAY['translator']),
                ('ctb', 'Contributor', 0, ARRAY['contributor', 'default']),
                ('his', 'Host institution', 0, ARRAY['affiliated_institution']),
                ('ths', 'Thesis advisor', 0, ARRAY['advisor']),
                ('oth', 'Other', -10000, ARRAY['other'])
              ) AS t(identifier, label, priority, tags)
          )
          INSERT INTO controlled_vocabulary_items (controlled_vocabulary_id, identifier, label, priority, tags)
          SELECT controlled_vocabulary_id, identifier, label, priority, tags FROM items
          ON CONFLICT (controlled_vocabulary_id, identifier) DO NOTHING;
          SQL
        end

        say_with_time "Populate initial contribution role configurations" do
          exec_update(<<~SQL)
          WITH default_vocab AS (
            SELECT "controlled_vocabularies"."id" AS controlled_vocabulary_id
            FROM "controlled_vocabularies"
            WHERE
              "controlled_vocabularies"."namespace" = 'meru.host'
              AND
              "controlled_vocabularies"."identifier" = 'marc_codes'
              AND
              "controlled_vocabularies"."version" = '1.0.0'
            LIMIT 1
          ), default_item AS (
            SELECT "controlled_vocabulary_items"."id" AS default_item_id
            FROM "controlled_vocabulary_items"
            INNER JOIN default_vocab USING (controlled_vocabulary_id)
            WHERE
              "controlled_vocabulary_items"."identifier" = 'ctb'
            LIMIT 1
          ), other_item AS (
            SELECT "controlled_vocabulary_items"."id" AS other_item_id
            FROM "controlled_vocabulary_items"
            INNER JOIN default_vocab USING (controlled_vocabulary_id)
            WHERE
              "controlled_vocabulary_items"."identifier" = 'oth'
            LIMIT 1
          ), gc AS (
            INSERT INTO global_configurations (guard)
            SELECT true
            ON CONFLICT DO NOTHING
          ), sources AS (
            SELECT id AS source_id, 'GlobalConfiguration' AS source_type FROM global_configurations
          ), configs AS (
            SELECT DISTINCT ON (source_id)
            controlled_vocabulary_id, default_item_id, other_item_id, source_id, source_type
            FROM sources
            CROSS JOIN default_vocab
            CROSS JOIN default_item
            CROSS JOIN other_item
          )
          INSERT INTO contribution_role_configurations (controlled_vocabulary_id, default_item_id, other_item_id, source_id, source_type)
          SELECT controlled_vocabulary_id, default_item_id, other_item_id, source_id, source_type FROM configs;
          SQL
        end
      end
    end
  end
end
