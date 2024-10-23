# frozen_string_literal: true

class AddTemplateConfigs < ActiveRecord::Migration[7.0]
  TEMPLATE_KINDS = %w[
    contributor_list
    descendant_list
    detail
    hero
    link_list
    list_item
    metadata
    navigation
    ordering
    page_list
    supplementary
  ].freeze

  def change
    safe_create_enum :descendant_list_variant, %w[cards compact grid promos summary]
    safe_create_enum :detail_variant, %w[full summary]
    safe_create_enum :link_list_variant, %w[cards compact grid promos summary]
    safe_create_enum :template_ordering_mode, %w[dynamic named manual]

    TEMPLATE_KINDS.each do |template_kind|
      safe_create_enum :"#{template_kind}_background", %w[none light dark]
    end
  end

  private

  def safe_create_enum(name, ...)
    reversible do |dir|
      dir.down do
        execute(<<~SQL.strip_heredoc.strip)
        DROP TYPE IF EXISTS #{name};
        SQL
      end
    end

    create_enum(name, ...)
  end
end
