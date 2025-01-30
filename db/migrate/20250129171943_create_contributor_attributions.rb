# frozen_string_literal: true

class CreateContributorAttributions < ActiveRecord::Migration[7.0]
  def change
    create_view :contributor_attributions, materialized: true

    change_table :contributor_attributions do |t|
      t.index :attribution_id, unique: true
      t.index %i[attribution_type attribution_id], name: "index_contributor_attributions_source"
      t.index %i[contributor_id published_rank], name: "index_contributor_published_ranking"
      t.index %i[contributor_id title_rank], name: "index_contributor_title_ranking"
      t.index %i[entity_type entity_id], name: "index_contributor_attributions_entity"
      t.index :item_id
    end
  end
end
