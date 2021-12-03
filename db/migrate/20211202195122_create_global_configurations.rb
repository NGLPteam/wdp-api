class CreateGlobalConfigurations < ActiveRecord::Migration[6.1]
  def change
    create_table :global_configurations, id: :uuid do |t|
      t.boolean :guard, null: false, default: true

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.jsonb :institution, null: false, default: {}
      t.jsonb :schema, null: false, default: {}
      t.jsonb :site, null: false, default: {}
      t.jsonb :theme, null: false, default: {}

      t.jsonb :logo_data
      t.jsonb :banner_data

      t.index :guard, unique: true, name: "index_global_configurations_singleton_guard"
    end

    reversible do |dir|
      dir.up do
        say_with_time "Add guard check constraint" do
          execute <<~SQL
          ALTER TABLE global_configurations ADD CONSTRAINT ensure_global_configurations_singleton CHECK (guard);
          SQL
        end
      end
    end
  end
end
