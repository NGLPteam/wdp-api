# frozen_string_literal: true

class ImproveContributorsAndAddModificationStatus < ActiveRecord::Migration[7.0]
  MODIFIABLE_TABLES = %w[
    contributors
    collections
    items
  ].freeze

  HARVEST_TABLES = MODIFIABLE_TABLES.index_with do |table_name|
    if table_name == "contributors"
      {
        harvest_table: "harvest_contributors",
        foreign_key: "contributor_id",
      }
    else
      {
        harvest_table: "harvest_entities",
        foreign_key: "entity_id",
      }
    end
  end.freeze

  def change
    create_enum "harvest_modification_status", %w[unharvested pristine modified]

    change_table :harvest_contributions do |t|
      t.rename :kind, :legacy_kind

      t.references :role, type: :uuid, null: true, foreign_key: { to_table: :controlled_vocabulary_items, on_delete: :restrict }
      t.bigint :inner_position
      t.bigint :outer_position
    end

    change_table :harvest_contributors do |t|
      t.text :tracked_attributes, null: false, default: [], array: true
      t.text :tracked_properties, null: false, default: [], array: true

      t.text :orcid
    end

    MODIFIABLE_TABLES.each do |table|
      change_table table do |t|
        t.enum :harvest_modification_status, enum_type: :harvest_modification_status, null: false, default: "unharvested"
      end

      reversible do |dir|
        dir.up do
          say_with_time "Detecting existing harvested records..." do
            HARVEST_TABLES.fetch(table) => { harvest_table:, foreign_key:, }

            exec_update(<<~SQL)
            UPDATE #{table} SET harvest_modification_status = 'pristine'
            WHERE id IN (SELECT DISTINCT #{foreign_key} FROM #{harvest_table} WHERE #{foreign_key} IS NOT NULL);
            SQL
          end
        end
      end
    end
  end
end
