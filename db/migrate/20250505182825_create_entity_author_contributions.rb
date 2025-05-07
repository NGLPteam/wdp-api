# frozen_string_literal: true

class CreateEntityAuthorContributions < ActiveRecord::Migration[7.0]
  def change
    create_view :entity_author_contributions, materialized: true

    change_table :entity_author_contributions do |t|
      t.index %i[entity_id contributor_id], unique: true, name: "index_entity_author_contributions_uniqueness"
      t.index %i[entity_id ranking], name: "index_entity_author_contributions_ranking"
    end
  end
end
