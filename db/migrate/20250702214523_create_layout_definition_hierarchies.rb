# frozen_string_literal: true

class CreateLayoutDefinitionHierarchies < ActiveRecord::Migration[7.0]
  def change
    create_enum :layout_definition_kind, %w[root leaf]

    create_table :layout_definition_hierarchies, id: :uuid do |t|
      t.references :schema_version, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :entity, null: true, polymorphic: true, type: :uuid
      t.references :layout_definition, null: false, polymorphic: true, type: :uuid, index: { unique: true }

      t.ltree :auth_path, null: false, default: ""

      t.enum :kind, enum_type: "layout_definition_kind", null: false

      t.enum :layout_kind, enum_type: "layout_kind", null: false

      t.virtual :depth, type: :integer, null: false, stored: true,
        as: %[nlevel(auth_path)]

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[schema_version_id auth_path layout_kind layout_definition_type layout_definition_id], using: :gist, name: "index_layout_definition_hierarchies_check"

      t.check_constraint <<~SQL.strip_heredoc.squish, name: "layout_definition_hierarchies_auth_path_sanity_check"
      CASE kind
      WHEN 'root' THEN nlevel(auth_path) = 0
      WHEN 'leaf' THEN nlevel(auth_path) > 0
      ELSE
        FALSE
      END
      SQL
    end

    reversible do |dir|
      dir.up do
        say_with_time "Populating layout definition hierarchies" do
          exec_update <<~SQL
          WITH initial_hierarchies AS (
            SELECT "layouts_hero_definitions"."schema_version_id", "layouts_hero_definitions"."entity_type", "layouts_hero_definitions"."entity_id", 'Layouts::HeroDefinition' AS layout_definition_type, "layouts_hero_definitions"."id" AS layout_definition_id, COALESCE("entities"."auth_path", CAST('' AS ltree)) AS auth_path, CASE WHEN "layouts_hero_definitions"."entity_id" IS NULL THEN 'root' ELSE 'leaf' END AS kind, "layouts_hero_definitions"."layout_kind" FROM "layouts_hero_definitions" LEFT OUTER JOIN "entities" ON "entities"."entity_id" = "layouts_hero_definitions"."entity_id"
            UNION ALL
            SELECT "layouts_list_item_definitions"."schema_version_id", "layouts_list_item_definitions"."entity_type", "layouts_list_item_definitions"."entity_id", 'Layouts::ListItemDefinition' AS layout_definition_type, "layouts_list_item_definitions"."id" AS layout_definition_id, COALESCE("entities"."auth_path", CAST('' AS ltree)) AS auth_path, CASE WHEN "layouts_list_item_definitions"."entity_id" IS NULL THEN 'root' ELSE 'leaf' END AS kind, "layouts_list_item_definitions"."layout_kind" FROM "layouts_list_item_definitions" LEFT OUTER JOIN "entities" ON "entities"."entity_id" = "layouts_list_item_definitions"."entity_id"
            UNION ALL
            SELECT "layouts_main_definitions"."schema_version_id", "layouts_main_definitions"."entity_type", "layouts_main_definitions"."entity_id", 'Layouts::MainDefinition' AS layout_definition_type, "layouts_main_definitions"."id" AS layout_definition_id, COALESCE("entities"."auth_path", CAST('' AS ltree)) AS auth_path, CASE WHEN "layouts_main_definitions"."entity_id" IS NULL THEN 'root' ELSE 'leaf' END AS kind, "layouts_main_definitions"."layout_kind" FROM "layouts_main_definitions" LEFT OUTER JOIN "entities" ON "entities"."entity_id" = "layouts_main_definitions"."entity_id"
            UNION ALL
            SELECT "layouts_navigation_definitions"."schema_version_id", "layouts_navigation_definitions"."entity_type", "layouts_navigation_definitions"."entity_id", 'Layouts::NavigationDefinition' AS layout_definition_type, "layouts_navigation_definitions"."id" AS layout_definition_id, COALESCE("entities"."auth_path", CAST('' AS ltree)) AS auth_path, CASE WHEN "layouts_navigation_definitions"."entity_id" IS NULL THEN 'root' ELSE 'leaf' END AS kind, "layouts_navigation_definitions"."layout_kind" FROM "layouts_navigation_definitions" LEFT OUTER JOIN "entities" ON "entities"."entity_id" = "layouts_navigation_definitions"."entity_id"
            UNION ALL
            SELECT "layouts_metadata_definitions"."schema_version_id", "layouts_metadata_definitions"."entity_type", "layouts_metadata_definitions"."entity_id", 'Layouts::MetadataDefinition' AS layout_definition_type, "layouts_metadata_definitions"."id" AS layout_definition_id, COALESCE("entities"."auth_path", CAST('' AS ltree)) AS auth_path, CASE WHEN "layouts_metadata_definitions"."entity_id" IS NULL THEN 'root' ELSE 'leaf' END AS kind, "layouts_metadata_definitions"."layout_kind" FROM "layouts_metadata_definitions" LEFT OUTER JOIN "entities" ON "entities"."entity_id" = "layouts_metadata_definitions"."entity_id"
            UNION ALL
            SELECT "layouts_supplementary_definitions"."schema_version_id", "layouts_supplementary_definitions"."entity_type", "layouts_supplementary_definitions"."entity_id", 'Layouts::SupplementaryDefinition' AS layout_definition_type, "layouts_supplementary_definitions"."id" AS layout_definition_id, COALESCE("entities"."auth_path", CAST('' AS ltree)) AS auth_path, CASE WHEN "layouts_supplementary_definitions"."entity_id" IS NULL THEN 'root' ELSE 'leaf' END AS kind, "layouts_supplementary_definitions"."layout_kind" FROM "layouts_supplementary_definitions" LEFT OUTER JOIN "entities" ON "entities"."entity_id" = "layouts_supplementary_definitions"."entity_id"
          )
          INSERT INTO layout_definition_hierarchies (schema_version_id, entity_type, entity_id, layout_definition_type, layout_definition_id, auth_path, kind, layout_kind)
          SELECT schema_version_id, entity_type, entity_id, layout_definition_type, layout_definition_id, auth_path, kind::layout_definition_kind, layout_kind FROM initial_hierarchies
          SQL
        end
      end
    end
  end
end
