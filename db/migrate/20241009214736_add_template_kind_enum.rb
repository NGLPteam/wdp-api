# frozen_string_literal: true

class AddTemplateKindEnum < ActiveRecord::Migration[7.0]
  LANG = "SQL"

  LAYOUT_KINDS = %w[
    hero
    list_item
    main
    navigation
    metadata
    supplementary
  ].freeze

  MAIN_TEMPLATE_KINDS = %w[
    detail
    descendant_list
    link_list
    page_list
    contributor_list
    ordering
  ].freeze

  TEMPLATE_KINDS = (LAYOUT_KINDS.without("main") + MAIN_TEMPLATE_KINDS).freeze

  DERIVED_TEMPLATE_KINDS = LAYOUT_KINDS.without("main").index_with { Array(_1) }.transform_keys { :"#{_1}_template_kind" }.merge(
    main_template_kind: MAIN_TEMPLATE_KINDS,
  )

  def change
    reversible do |dir|
      dir.down do
        DERIVED_TEMPLATE_KINDS.each_key do |type|
          execute <<~SQL.strip_heredoc.strip
          DROP TYPE IF EXISTS #{type};
          SQL
        end

        execute <<~SQL.strip_heredoc.strip
        DROP TYPE layout_kind;
        DROP TYPE template_kind;
        DROP TYPE template_slot_kind;
        SQL
      end
    end

    create_enum :layout_kind, LAYOUT_KINDS

    create_enum :template_slot_kind, %w[block inline]

    create_enum :template_kind, TEMPLATE_KINDS

    DERIVED_TEMPLATE_KINDS.each do |type, kinds|
      create_enum type, kinds

      reversible do |dir|
        dir.up do
          execute <<~SQL.strip_heredoc.strip
          CREATE FUNCTION is_#{type}(template_kind) RETURNS boolean AS $$
          SELECT $1::text = ANY(enum_range(NULL::#{type})::text[]);
          $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

          CREATE FUNCTION is_#{type}(text) RETURNS boolean AS $$
          SELECT $1 = ANY(enum_range(NULL::#{type})::text[]);
          $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;
          SQL
        end

        dir.down do
          execute <<~SQL.strip_heredoc.strip
          DROP FUNCTION is_#{type}(template_kind);
          DROP FUNCTION is_#{type}(text);
          SQL
        end
      end
    end
  end
end
