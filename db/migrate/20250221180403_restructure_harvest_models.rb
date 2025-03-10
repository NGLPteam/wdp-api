# frozen_string_literal: true

class RestructureHarvestModels < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :harvest_entities, :harvest_records, on_delete: :cascade

    rename_index :harvest_records, "index_harvest_records_uniqueness", "legacy_index_harvest_records_uniqueness"

    rename_table :harvest_records, :legacy_harvest_records

    create_table :harvest_records, id: :uuid do |t|
      t.references :harvest_source, null: false, type: :uuid, foreign_key: { on_delete: :cascade }

      t.enum :status, enum_type: :harvest_record_status, null: false, default: "pending"

      t.text :identifier, null: false
      t.text :metadata_format, null: false
      t.text :raw_source
      t.text :raw_metadata_source

      t.bigint :entity_count

      t.timestamp :source_changed_at

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.jsonb :local_metadata, null: false, default: {}
      t.jsonb :skipped, null: false, default: { active: false }

      t.index %i[harvest_source_id identifier], unique: true, name: "index_harvest_records_uniqueness"
      t.index :status
    end

    create_table :harvest_attempt_record_links, id: :uuid do |t|
      t.references :harvest_attempt, null: false, type: :uuid, foreign_key: { on_delete: :cascade }
      t.references :harvest_record, null: false, type: :uuid, foreign_key: { on_delete: :cascade }

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[harvest_attempt_id harvest_record_id], unique: true, name: "index_harvest_attempt_record_uniqueness"
    end

    create_table :harvest_mapping_record_links, id: :uuid do |t|
      t.references :harvest_mapping, null: false, type: :uuid, foreign_key: { on_delete: :cascade }
      t.references :harvest_record, null: false, type: :uuid, foreign_key: { on_delete: :cascade }

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[harvest_mapping_id harvest_record_id], unique: true, name: "index_harvest_mapping_record_uniqueness"
    end

    create_table :harvest_set_record_links, id: :uuid do |t|
      t.references :harvest_set, null: false, type: :uuid, foreign_key: { on_delete: :cascade }
      t.references :harvest_record, null: false, type: :uuid, foreign_key: { on_delete: :cascade }

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[harvest_set_id harvest_record_id], unique: true, name: "index_harvest_set_record_uniqueness"
    end

    reversible do |dir|
      dir.up do
        say_with_time "Creating a temporary table for storing authoritative harvest records" do
          execute(<<~SQL)
          CREATE TEMPORARY TABLE authoritative_harvest_records AS
          WITH record_sources AS (
            SELECT
              ha.harvest_source_id,
              hr.identifier,
              hr.harvest_attempt_id
            FROM legacy_harvest_records hr
            INNER JOIN harvest_attempts ha ON ha.id = hr.harvest_attempt_id
          ), ha_ids AS (
            SELECT harvest_source_id, identifier, ARRAY_AGG(DISTINCT harvest_attempt_id) AS harvest_attempt_ids
            FROM record_sources
            GROUP BY 1, 2
          )
          SELECT DISTINCT ON (harvest_source_id, identifier)
            hr.id,
            harvest_source_id,
            CASE
            WHEN hr.has_been_skipped THEN 'skipped'::harvest_record_status
            ELSE
              'active'::harvest_record_status
            END AS status,
            hr.identifier,
            hr.metadata_format,
            hr.raw_source,
            hr.raw_metadata_source,
            hr.entity_count,
            hr.datestamp::timestamp AS source_changed_at,
            ha_ids.harvest_attempt_ids,
            hr.created_at,
            hr.updated_at,
            hr.local_metadata,
            hr.skipped
            FROM legacy_harvest_records hr
            INNER JOIN record_sources USING (harvest_attempt_id, identifier)
            INNER JOIN ha_ids USING (harvest_source_id, identifier)
            ORDER BY harvest_source_id, identifier, hr.created_at DESC
          ;
          SQL
        end

        say_with_time "Populating normalized harvest records" do
          exec_update(<<~SQL)
          INSERT INTO harvest_records (
            id, harvest_source_id, status, identifier, metadata_format,
            raw_source, raw_metadata_source, entity_count,
            source_changed_at, created_at, updated_at, local_metadata, skipped
          )
          SELECT
            id, harvest_source_id, status, identifier, metadata_format,
            raw_source, raw_metadata_source, entity_count,
            source_changed_at, created_at, updated_at, local_metadata, skipped
          FROM authoritative_harvest_records
          SQL
        end

        say_with_time "Populating harvest attempt record links" do
          exec_update(<<~SQL)
          INSERT INTO harvest_attempt_record_links (harvest_attempt_id, harvest_record_id)
          SELECT DISTINCT
            harvest_attempt_id, hr.id AS harvest_record_id
          FROM authoritative_harvest_records hr, unnest(harvest_attempt_ids) AS x(harvest_attempt_id)
          SQL
        end

        say_with_time "Populating harvest mapping record links" do
          exec_update(<<~SQL)
          INSERT INTO harvest_mapping_record_links (harvest_mapping_id, harvest_record_id)
          SELECT DISTINCT
            ha.harvest_mapping_id, harl.harvest_record_id
          FROM harvest_attempt_record_links harl
          INNER JOIN harvest_attempts ha ON ha.id = harl.harvest_attempt_id AND ha.harvest_mapping_id IS NOT NULL
          SQL
        end

        say_with_time "Populating harvest set record links" do
          exec_update(<<~SQL)
          INSERT INTO harvest_set_record_links (harvest_set_id, harvest_record_id)
          SELECT DISTINCT
            ha.harvest_set_id, harl.harvest_record_id
          FROM harvest_attempt_record_links harl
          INNER JOIN harvest_attempts ha ON ha.id = harl.harvest_attempt_id AND ha.harvest_set_id IS NOT NULL
          SQL
        end

        say_with_time "Pruning old harvest contributions" do
          exec_delete(<<~SQL)
          DELETE FROM harvest_contributions WHERE harvest_entity_id IN (
            SELECT he.id FROM harvest_entities he
            LEFT OUTER JOIN harvest_records hr ON hr.id = he.harvest_record_id
            WHERE hr.id is null
          )
          SQL
        end

        say_with_time "Pruning old harvest entities" do
          exec_delete(<<~SQL)
          DELETE FROM harvest_entities WHERE harvest_record_id NOT IN (SELECT id FROM harvest_records);
          SQL
        end
      end
    end

    add_foreign_key :harvest_entities, :harvest_records, on_delete: :cascade
  end
end
