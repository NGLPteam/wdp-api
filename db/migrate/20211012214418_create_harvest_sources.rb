class CreateHarvestSources < ActiveRecord::Migration[6.1]
  def change
    create_table :harvest_sources, id: :uuid do |t|
      t.text :name,             null: false
      t.text :kind,             null: false
      t.text :source_format,    null: false
      t.text :base_url,         null: false
      t.text :description

      t.jsonb :list_options,    null: false, default: {}
      t.jsonb :read_options,    null: false, default: {}
      t.jsonb :format_options,  null: false, default: {}
      t.jsonb :mapping_options, null: false, default: {}

      t.timestamp :sets_refreshed_at, null: true
      t.timestamp :last_harvested_at, null: true

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }
    end
  end
end
