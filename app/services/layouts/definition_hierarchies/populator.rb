# frozen_string_literal: true

module Layouts
  module DefinitionHierarchies
    # @see Layouts::DefinitionHierarchies::Populate
    class Populator < Support::HookBased::Actor
      include QueryOperation

      QUERY = <<~SQL
      WITH hierarchies AS (
        SELECT "layouts_hero_definitions"."schema_version_id", "layouts_hero_definitions"."entity_type", "layouts_hero_definitions"."entity_id", 'Layouts::HeroDefinition' AS layout_definition_type, "layouts_hero_definitions"."id" AS layout_definition_id,
          COALESCE("entities"."auth_path", CAST('' AS ltree)) AS auth_path, CASE WHEN "layouts_hero_definitions"."entity_id" IS NULL THEN 'root' ELSE 'leaf' END AS kind, "layouts_hero_definitions"."layout_kind"
        FROM "layouts_hero_definitions"
        LEFT OUTER JOIN "entities" ON "entities"."entity_id" = "layouts_hero_definitions"."entity_id"
        UNION ALL
        SELECT "layouts_list_item_definitions"."schema_version_id", "layouts_list_item_definitions"."entity_type", "layouts_list_item_definitions"."entity_id", 'Layouts::ListItemDefinition' AS layout_definition_type, "layouts_list_item_definitions"."id" AS layout_definition_id,
          COALESCE("entities"."auth_path", CAST('' AS ltree)) AS auth_path, CASE WHEN "layouts_list_item_definitions"."entity_id" IS NULL THEN 'root' ELSE 'leaf' END AS kind, "layouts_list_item_definitions"."layout_kind"
        FROM "layouts_list_item_definitions"
        LEFT OUTER JOIN "entities" ON "entities"."entity_id" = "layouts_list_item_definitions"."entity_id"
        UNION ALL
        SELECT "layouts_main_definitions"."schema_version_id", "layouts_main_definitions"."entity_type", "layouts_main_definitions"."entity_id", 'Layouts::MainDefinition' AS layout_definition_type, "layouts_main_definitions"."id" AS layout_definition_id,
          COALESCE("entities"."auth_path", CAST('' AS ltree)) AS auth_path, CASE WHEN "layouts_main_definitions"."entity_id" IS NULL THEN 'root' ELSE 'leaf' END AS kind, "layouts_main_definitions"."layout_kind"
        FROM "layouts_main_definitions"
        LEFT OUTER JOIN "entities" ON "entities"."entity_id" = "layouts_main_definitions"."entity_id"
        UNION ALL
        SELECT "layouts_navigation_definitions"."schema_version_id", "layouts_navigation_definitions"."entity_type", "layouts_navigation_definitions"."entity_id", 'Layouts::NavigationDefinition' AS layout_definition_type, "layouts_navigation_definitions"."id" AS layout_definition_id,
          COALESCE("entities"."auth_path", CAST('' AS ltree)) AS auth_path, CASE WHEN "layouts_navigation_definitions"."entity_id" IS NULL THEN 'root' ELSE 'leaf' END AS kind, "layouts_navigation_definitions"."layout_kind"
        FROM "layouts_navigation_definitions"
        LEFT OUTER JOIN "entities" ON "entities"."entity_id" = "layouts_navigation_definitions"."entity_id"
        UNION ALL
        SELECT "layouts_metadata_definitions"."schema_version_id", "layouts_metadata_definitions"."entity_type", "layouts_metadata_definitions"."entity_id", 'Layouts::MetadataDefinition' AS layout_definition_type, "layouts_metadata_definitions"."id" AS layout_definition_id,
          COALESCE("entities"."auth_path", CAST('' AS ltree)) AS auth_path, CASE WHEN "layouts_metadata_definitions"."entity_id" IS NULL THEN 'root' ELSE 'leaf' END AS kind, "layouts_metadata_definitions"."layout_kind"
        FROM "layouts_metadata_definitions"
        LEFT OUTER JOIN "entities" ON "entities"."entity_id" = "layouts_metadata_definitions"."entity_id"
        UNION ALL
        SELECT "layouts_supplementary_definitions"."schema_version_id", "layouts_supplementary_definitions"."entity_type", "layouts_supplementary_definitions"."entity_id", 'Layouts::SupplementaryDefinition' AS layout_definition_type, "layouts_supplementary_definitions"."id" AS layout_definition_id,
          COALESCE("entities"."auth_path", CAST('' AS ltree)) AS auth_path, CASE WHEN "layouts_supplementary_definitions"."entity_id" IS NULL THEN 'root' ELSE 'leaf' END AS kind, "layouts_supplementary_definitions"."layout_kind"
        FROM "layouts_supplementary_definitions"
        LEFT OUTER JOIN "entities" ON "entities"."entity_id" = "layouts_supplementary_definitions"."entity_id"
      )
      INSERT INTO layout_definition_hierarchies (schema_version_id, entity_type, entity_id, layout_definition_type, layout_definition_id, auth_path, kind, layout_kind)
      SELECT schema_version_id, entity_type, entity_id, layout_definition_type, layout_definition_id, auth_path, kind::layout_definition_kind, layout_kind FROM hierarchies
      ON CONFLICT (layout_definition_type, layout_definition_id) DO UPDATE SET
        schema_version_id = EXCLUDED.schema_version_id,
        entity_type = EXCLUDED.entity_type,
        entity_id = EXCLUDED.entity_id,
        auth_path = EXCLUDED.auth_path,
        kind = EXCLUDED.kind,
        layout_kind = EXCLUDED.layout_kind,
        updated_at = CURRENT_TIMESTAMP
      SQL

      standard_execution!

      attr_reader :upserted

      # @return [Dry::Monads::Result]
      def call
        run_callbacks :execute do
          yield execute_query!
        end

        Success upserted
      end

      wrapped_hook! def execute_query
        @upserted = sql_update!(QUERY)

        super
      end
    end
  end
end
