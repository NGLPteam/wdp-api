class CreateLayoutsInstanceDigests < ActiveRecord::Migration[7.0]
  def change
    create_table :layouts_instance_digests, id: :uuid do |t|
      t.references :layout_definition, polymorphic: true, null: false, type: :uuid
      t.references :layout_instance, polymorphic: true, null: false, type: :uuid, index: { unique: true }
      t.references :entity, polymorphic: true, null: false, type: :uuid

      t.enum :layout_kind, enum_type: "layout_kind", null: false

      t.uuid :generation, null: false

      t.jsonb :config, null: false, default: {}

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[layout_definition_id entity_type entity_id], name: "index_layout_instance_digest_check"
    end

    reversible do |dir|
      dir.up do
        say_with_time "Populating layouts/instance_digests" do
          exec_update(<<~SQL)
          WITH initial_digests AS (
            SELECT 'Layouts::HeroDefinition' AS layout_definition_type, "layouts_hero_instances"."layout_definition_id", 'Layouts::HeroInstance' AS layout_instance_type, "layouts_hero_instances"."id" AS layout_instance_id, "layouts_hero_instances"."entity_type", "layouts_hero_instances"."entity_id", "layouts_hero_instances"."layout_kind", "layouts_hero_instances"."generation", "layouts_hero_instances"."config", "layouts_hero_instances"."created_at", "layouts_hero_instances"."updated_at" FROM "layouts_hero_instances"
            UNION ALL
            SELECT 'Layouts::ListItemDefinition' AS layout_definition_type, "layouts_list_item_instances"."layout_definition_id", 'Layouts::ListItemInstance' AS layout_instance_type, "layouts_list_item_instances"."id" AS layout_instance_id, "layouts_list_item_instances"."entity_type", "layouts_list_item_instances"."entity_id", "layouts_list_item_instances"."layout_kind", "layouts_list_item_instances"."generation", "layouts_list_item_instances"."config", "layouts_list_item_instances"."created_at", "layouts_list_item_instances"."updated_at" FROM "layouts_list_item_instances"
            UNION ALL
            SELECT 'Layouts::MainDefinition' AS layout_definition_type, "layouts_main_instances"."layout_definition_id", 'Layouts::MainInstance' AS layout_instance_type, "layouts_main_instances"."id" AS layout_instance_id, "layouts_main_instances"."entity_type", "layouts_main_instances"."entity_id", "layouts_main_instances"."layout_kind", "layouts_main_instances"."generation", "layouts_main_instances"."config", "layouts_main_instances"."created_at", "layouts_main_instances"."updated_at" FROM "layouts_main_instances"
            UNION ALL
            SELECT 'Layouts::NavigationDefinition' AS layout_definition_type, "layouts_navigation_instances"."layout_definition_id", 'Layouts::NavigationInstance' AS layout_instance_type, "layouts_navigation_instances"."id" AS layout_instance_id, "layouts_navigation_instances"."entity_type", "layouts_navigation_instances"."entity_id", "layouts_navigation_instances"."layout_kind", "layouts_navigation_instances"."generation", "layouts_navigation_instances"."config", "layouts_navigation_instances"."created_at", "layouts_navigation_instances"."updated_at" FROM "layouts_navigation_instances"
            UNION ALL
            SELECT 'Layouts::MetadataDefinition' AS layout_definition_type, "layouts_metadata_instances"."layout_definition_id", 'Layouts::MetadataInstance' AS layout_instance_type, "layouts_metadata_instances"."id" AS layout_instance_id, "layouts_metadata_instances"."entity_type", "layouts_metadata_instances"."entity_id", "layouts_metadata_instances"."layout_kind", "layouts_metadata_instances"."generation", "layouts_metadata_instances"."config", "layouts_metadata_instances"."created_at", "layouts_metadata_instances"."updated_at" FROM "layouts_metadata_instances"
            UNION ALL
            SELECT 'Layouts::SupplementaryDefinition' AS layout_definition_type, "layouts_supplementary_instances"."layout_definition_id", 'Layouts::SupplementaryInstance' AS layout_instance_type, "layouts_supplementary_instances"."id" AS layout_instance_id, "layouts_supplementary_instances"."entity_type", "layouts_supplementary_instances"."entity_id", "layouts_supplementary_instances"."layout_kind", "layouts_supplementary_instances"."generation", "layouts_supplementary_instances"."config", "layouts_supplementary_instances"."created_at", "layouts_supplementary_instances"."updated_at" FROM "layouts_supplementary_instances"
          )
          INSERT INTO layouts_instance_digests (layout_definition_type, layout_definition_id, layout_instance_type, layout_instance_id, entity_type, entity_id, layout_kind, generation, config, created_at, updated_at)
          SELECT layout_definition_type, layout_definition_id, layout_instance_type, layout_instance_id, entity_type, entity_id, layout_kind, generation, config, created_at, updated_at FROM initial_digests
          SQL
        end
      end
    end
  end
end
