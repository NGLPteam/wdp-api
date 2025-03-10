# frozen_string_literal: true

class RemoveORCIDUniquenessConstraint < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      dir.up do
        execute <<~SQL
        DROP INDEX IF EXISTS "index_contributors_on_orcid";
        SQL
      end
    end

    add_index :contributors, :orcid
  end
end
