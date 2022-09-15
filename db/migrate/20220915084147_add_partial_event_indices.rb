class AddPartialEventIndices < ActiveRecord::Migration[6.1]
  def change
    change_table :ahoy_events do |t|
      t.index %i[time visit_id entity_id subject_id],
        name: "index_ahoy_events_entity_views_aggregation",
        where: %[context = 'frontend' AND name = 'entity.view']

      t.index %i[time visit_id entity_id subject_id],
        name: "index_ahoy_events_asset_downloads_aggregation",
        where: %[context = 'frontend' AND name = 'asset.download']
    end
  end
end
