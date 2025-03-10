# frozen_string_literal: true

class AlterHarvestContributionsUniqueness < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      dir.up do
        execute <<~SQL
        DROP INDEX IF EXISTS "index_harvest_contributions_uniqueness";
        SQL
      end
    end

    change_table :harvest_contributions do |t|
      t.index %i[harvest_contributor_id harvest_entity_id role_id], unique: true, name: "harvest_contributions_with_role_uniqueness", where: %[role_id IS NOT NULL]
      t.index %i[harvest_contributor_id harvest_entity_id], unique: true, name: "harvest_contributions_sans_role_uniqueness", where: %[role_id IS NULL]
    end
  end
end
