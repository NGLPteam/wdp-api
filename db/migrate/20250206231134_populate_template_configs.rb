# frozen_string_literal: true

class PopulateTemplateConfigs < ActiveRecord::Migration[7.0]
  def up
    say_with_time "Populating templates_hero_definitions.config" do
      exec_update(<<~SQL.strip_heredoc)
      UPDATE "templates_hero_definitions" SET "config" = jsonb_build_object('background', "templates_hero_definitions"."background", 'dark', "templates_hero_definitions"."background" = 'dark')
      SQL
    end

    say_with_time "Populating templates_blurb_definitions.config" do
      exec_update(<<~SQL.strip_heredoc)
      UPDATE "templates_blurb_definitions" SET "config" = jsonb_build_object('background', "templates_blurb_definitions"."background", 'dark', "templates_blurb_definitions"."background" = 'dark')
      SQL
    end

    say_with_time "Populating templates_detail_definitions.config" do
      exec_update(<<~SQL.strip_heredoc)
      UPDATE "templates_detail_definitions" SET "config" = jsonb_build_object('background', "templates_detail_definitions"."background", 'dark', "templates_detail_definitions"."background" = 'dark', 'variant', "templates_detail_definitions"."variant")
      SQL
    end

    say_with_time "Populating templates_descendant_list_definitions.config" do
      exec_update(<<~SQL.strip_heredoc)
      UPDATE "templates_descendant_list_definitions" SET "config" = jsonb_build_object('background', "templates_descendant_list_definitions"."background", 'dark', "templates_descendant_list_definitions"."background" = 'dark', 'variant', "templates_descendant_list_definitions"."variant")
      SQL
    end

    say_with_time "Populating templates_link_list_definitions.config" do
      exec_update(<<~SQL.strip_heredoc)
      UPDATE "templates_link_list_definitions" SET "config" = jsonb_build_object('background', "templates_link_list_definitions"."background", 'dark', "templates_link_list_definitions"."background" = 'dark', 'variant', "templates_link_list_definitions"."variant")
      SQL
    end

    say_with_time "Populating templates_page_list_definitions.config" do
      exec_update(<<~SQL.strip_heredoc)
      UPDATE "templates_page_list_definitions" SET "config" = jsonb_build_object('background', "templates_page_list_definitions"."background", 'dark', "templates_page_list_definitions"."background" = 'dark')
      SQL
    end

    say_with_time "Populating templates_contributor_list_definitions.config" do
      exec_update(<<~SQL.strip_heredoc)
      UPDATE "templates_contributor_list_definitions" SET "config" = jsonb_build_object('background', "templates_contributor_list_definitions"."background", 'dark', "templates_contributor_list_definitions"."background" = 'dark')
      SQL
    end

    say_with_time "Populating templates_ordering_definitions.config" do
      exec_update(<<~SQL.strip_heredoc)
      UPDATE "templates_ordering_definitions" SET "config" = jsonb_build_object('background', "templates_ordering_definitions"."background", 'dark', "templates_ordering_definitions"."background" = 'dark')
      SQL
    end

    say_with_time "Populating templates_navigation_definitions.config" do
      exec_update(<<~SQL.strip_heredoc)
      UPDATE "templates_navigation_definitions" SET "config" = jsonb_build_object('background', "templates_navigation_definitions"."background", 'dark', "templates_navigation_definitions"."background" = 'dark')
      SQL
    end

    say_with_time "Populating templates_metadata_definitions.config" do
      exec_update(<<~SQL.strip_heredoc)
      UPDATE "templates_metadata_definitions" SET "config" = jsonb_build_object('background', "templates_metadata_definitions"."background", 'dark', "templates_metadata_definitions"."background" = 'dark')
      SQL
    end

    say_with_time "Populating templates_supplementary_definitions.config" do
      exec_update(<<~SQL.strip_heredoc)
      UPDATE "templates_supplementary_definitions" SET "config" = jsonb_build_object('background', "templates_supplementary_definitions"."background", 'dark', "templates_supplementary_definitions"."background" = 'dark')
      SQL
    end

    say_with_time "Populating templates_hero_instances.config" do
      exec_update(<<~SQL.strip_heredoc)
      UPDATE templates_hero_instances SET config = templates_hero_definitions.config
      FROM templates_hero_definitions
      WHERE templates_hero_instances."template_definition_id" = templates_hero_definitions."id"
      SQL
    end

    say_with_time "Populating templates_blurb_instances.config" do
      exec_update(<<~SQL.strip_heredoc)
      UPDATE templates_blurb_instances SET config = templates_blurb_definitions.config
      FROM templates_blurb_definitions
      WHERE templates_blurb_instances."template_definition_id" = templates_blurb_definitions."id"
      SQL
    end

    say_with_time "Populating templates_detail_instances.config" do
      exec_update(<<~SQL.strip_heredoc)
      UPDATE templates_detail_instances SET config = templates_detail_definitions.config
      FROM templates_detail_definitions
      WHERE templates_detail_instances."template_definition_id" = templates_detail_definitions."id"
      SQL
    end

    say_with_time "Populating templates_descendant_list_instances.config" do
      exec_update(<<~SQL.strip_heredoc)
      UPDATE templates_descendant_list_instances SET config = templates_descendant_list_definitions.config
      FROM templates_descendant_list_definitions
      WHERE templates_descendant_list_instances."template_definition_id" = templates_descendant_list_definitions."id"
      SQL
    end

    say_with_time "Populating templates_link_list_instances.config" do
      exec_update(<<~SQL.strip_heredoc)
      UPDATE templates_link_list_instances SET config = templates_link_list_definitions.config
      FROM templates_link_list_definitions
      WHERE templates_link_list_instances."template_definition_id" = templates_link_list_definitions."id"
      SQL
    end

    say_with_time "Populating templates_page_list_instances.config" do
      exec_update(<<~SQL.strip_heredoc)
      UPDATE templates_page_list_instances SET config = templates_page_list_definitions.config
      FROM templates_page_list_definitions
      WHERE templates_page_list_instances."template_definition_id" = templates_page_list_definitions."id"
      SQL
    end

    say_with_time "Populating templates_contributor_list_instances.config" do
      exec_update(<<~SQL.strip_heredoc)
      UPDATE templates_contributor_list_instances SET config = templates_contributor_list_definitions.config
      FROM templates_contributor_list_definitions
      WHERE templates_contributor_list_instances."template_definition_id" = templates_contributor_list_definitions."id"
      SQL
    end

    say_with_time "Populating templates_ordering_instances.config" do
      exec_update(<<~SQL.strip_heredoc)
      UPDATE templates_ordering_instances SET config = templates_ordering_definitions.config
      FROM templates_ordering_definitions
      WHERE templates_ordering_instances."template_definition_id" = templates_ordering_definitions."id"
      SQL
    end

    say_with_time "Populating templates_navigation_instances.config" do
      exec_update(<<~SQL.strip_heredoc)
      UPDATE templates_navigation_instances SET config = templates_navigation_definitions.config
      FROM templates_navigation_definitions
      WHERE templates_navigation_instances."template_definition_id" = templates_navigation_definitions."id"
      SQL
    end

    say_with_time "Populating templates_metadata_instances.config" do
      exec_update(<<~SQL.strip_heredoc)
      UPDATE templates_metadata_instances SET config = templates_metadata_definitions.config
      FROM templates_metadata_definitions
      WHERE templates_metadata_instances."template_definition_id" = templates_metadata_definitions."id"
      SQL
    end

    say_with_time "Populating templates_supplementary_instances.config" do
      exec_update(<<~SQL.strip_heredoc)
      UPDATE templates_supplementary_instances SET config = templates_supplementary_definitions.config
      FROM templates_supplementary_definitions
      WHERE templates_supplementary_instances."template_definition_id" = templates_supplementary_definitions."id"
      SQL
    end
  end

  def down
    # Nothing to do, this is a data migration.
  end
end
