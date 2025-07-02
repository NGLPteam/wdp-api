# frozen_string_literal: true

class CreateTemplatesDefinitionDigests < ActiveRecord::Migration[7.0]
  def change
    create_table :templates_definition_digests, id: :uuid do |t|
      t.references :layout_definition, polymorphic: true, null: false, type: :uuid
      t.references :template_definition, polymorphic: true, null: false, type: :uuid, index: { unique: true }

      t.bigint :position

      t.enum :layout_kind, enum_type: "layout_kind", null: false
      t.enum :template_kind, enum_type: "template_kind", null: false

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }
    end

    change_table :entities do |t|
      t.virtual :real, type: :boolean, null: false, stored: true,
        as: %[scope IN ('communities', 'collections', 'items')]

      t.index %i[auth_path schema_version_id entity_type entity_id], name: "index_entities_check", where: %[real], using: :gist
    end

    change_table :templates_instance_digests do |t|
      t.index %i[entity_type entity_id layout_definition_id template_definition_id], name: "index_template_instance_digests_check"
    end

    reversible do |dir|
      dir.up do
        say_with_time "Populating templates/definition_digests" do
          exec_update(<<~SQL)
          WITH initial_digests AS (
            SELECT 'Layouts::HeroDefinition' AS layout_definition_type, "templates_hero_definitions"."layout_definition_id", 'Templates::HeroDefinition' AS template_definition_type, "templates_hero_definitions"."id" AS template_definition_id, "templates_hero_definitions"."position", "templates_hero_definitions"."layout_kind", "templates_hero_definitions"."template_kind", "templates_hero_definitions"."created_at", "templates_hero_definitions"."updated_at" FROM "templates_hero_definitions"
            UNION ALL
            SELECT 'Layouts::ListItemDefinition' AS layout_definition_type, "templates_list_item_definitions"."layout_definition_id", 'Templates::ListItemDefinition' AS template_definition_type, "templates_list_item_definitions"."id" AS template_definition_id, "templates_list_item_definitions"."position", "templates_list_item_definitions"."layout_kind", "templates_list_item_definitions"."template_kind", "templates_list_item_definitions"."created_at", "templates_list_item_definitions"."updated_at" FROM "templates_list_item_definitions"
            UNION ALL
            SELECT 'Layouts::MainDefinition' AS layout_definition_type, "templates_blurb_definitions"."layout_definition_id", 'Templates::BlurbDefinition' AS template_definition_type, "templates_blurb_definitions"."id" AS template_definition_id, "templates_blurb_definitions"."position", "templates_blurb_definitions"."layout_kind", "templates_blurb_definitions"."template_kind", "templates_blurb_definitions"."created_at", "templates_blurb_definitions"."updated_at" FROM "templates_blurb_definitions"
            UNION ALL
            SELECT 'Layouts::MainDefinition' AS layout_definition_type, "templates_detail_definitions"."layout_definition_id", 'Templates::DetailDefinition' AS template_definition_type, "templates_detail_definitions"."id" AS template_definition_id, "templates_detail_definitions"."position", "templates_detail_definitions"."layout_kind", "templates_detail_definitions"."template_kind", "templates_detail_definitions"."created_at", "templates_detail_definitions"."updated_at" FROM "templates_detail_definitions"
            UNION ALL
            SELECT 'Layouts::MainDefinition' AS layout_definition_type, "templates_descendant_list_definitions"."layout_definition_id", 'Templates::DescendantListDefinition' AS template_definition_type, "templates_descendant_list_definitions"."id" AS template_definition_id, "templates_descendant_list_definitions"."position", "templates_descendant_list_definitions"."layout_kind", "templates_descendant_list_definitions"."template_kind", "templates_descendant_list_definitions"."created_at", "templates_descendant_list_definitions"."updated_at" FROM "templates_descendant_list_definitions"
            UNION ALL
            SELECT 'Layouts::MainDefinition' AS layout_definition_type, "templates_link_list_definitions"."layout_definition_id", 'Templates::LinkListDefinition' AS template_definition_type, "templates_link_list_definitions"."id" AS template_definition_id, "templates_link_list_definitions"."position", "templates_link_list_definitions"."layout_kind", "templates_link_list_definitions"."template_kind", "templates_link_list_definitions"."created_at", "templates_link_list_definitions"."updated_at" FROM "templates_link_list_definitions"
            UNION ALL
            SELECT 'Layouts::MainDefinition' AS layout_definition_type, "templates_page_list_definitions"."layout_definition_id", 'Templates::PageListDefinition' AS template_definition_type, "templates_page_list_definitions"."id" AS template_definition_id, "templates_page_list_definitions"."position", "templates_page_list_definitions"."layout_kind", "templates_page_list_definitions"."template_kind", "templates_page_list_definitions"."created_at", "templates_page_list_definitions"."updated_at" FROM "templates_page_list_definitions"
            UNION ALL
            SELECT 'Layouts::MainDefinition' AS layout_definition_type, "templates_contributor_list_definitions"."layout_definition_id", 'Templates::ContributorListDefinition' AS template_definition_type, "templates_contributor_list_definitions"."id" AS template_definition_id, "templates_contributor_list_definitions"."position", "templates_contributor_list_definitions"."layout_kind", "templates_contributor_list_definitions"."template_kind", "templates_contributor_list_definitions"."created_at", "templates_contributor_list_definitions"."updated_at" FROM "templates_contributor_list_definitions"
            UNION ALL
            SELECT 'Layouts::MainDefinition' AS layout_definition_type, "templates_ordering_definitions"."layout_definition_id", 'Templates::OrderingDefinition' AS template_definition_type, "templates_ordering_definitions"."id" AS template_definition_id, "templates_ordering_definitions"."position", "templates_ordering_definitions"."layout_kind", "templates_ordering_definitions"."template_kind", "templates_ordering_definitions"."created_at", "templates_ordering_definitions"."updated_at" FROM "templates_ordering_definitions"
            UNION ALL
            SELECT 'Layouts::NavigationDefinition' AS layout_definition_type, "templates_navigation_definitions"."layout_definition_id", 'Templates::NavigationDefinition' AS template_definition_type, "templates_navigation_definitions"."id" AS template_definition_id, "templates_navigation_definitions"."position", "templates_navigation_definitions"."layout_kind", "templates_navigation_definitions"."template_kind", "templates_navigation_definitions"."created_at", "templates_navigation_definitions"."updated_at" FROM "templates_navigation_definitions"
            UNION ALL
            SELECT 'Layouts::MetadataDefinition' AS layout_definition_type, "templates_metadata_definitions"."layout_definition_id", 'Templates::MetadataDefinition' AS template_definition_type, "templates_metadata_definitions"."id" AS template_definition_id, "templates_metadata_definitions"."position", "templates_metadata_definitions"."layout_kind", "templates_metadata_definitions"."template_kind", "templates_metadata_definitions"."created_at", "templates_metadata_definitions"."updated_at" FROM "templates_metadata_definitions"
            UNION ALL
            SELECT 'Layouts::SupplementaryDefinition' AS layout_definition_type, "templates_supplementary_definitions"."layout_definition_id", 'Templates::SupplementaryDefinition' AS template_definition_type, "templates_supplementary_definitions"."id" AS template_definition_id, "templates_supplementary_definitions"."position", "templates_supplementary_definitions"."layout_kind", "templates_supplementary_definitions"."template_kind", "templates_supplementary_definitions"."created_at", "templates_supplementary_definitions"."updated_at" FROM "templates_supplementary_definitions"
          )
          INSERT INTO templates_definition_digests (layout_definition_type, layout_definition_id, template_definition_type, template_definition_id, position, layout_kind, template_kind, created_at, updated_at)
          SELECT layout_definition_type, layout_definition_id, template_definition_type, template_definition_id, position, layout_kind, template_kind, created_at, updated_at FROM initial_digests;
          SQL
        end
      end
    end
  end
end
