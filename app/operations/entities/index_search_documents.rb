# frozen_string_literal: true

module Entities
  class IndexSearchDocuments
    include Dry::Monads[:result]
    include QueryOperation

    PREFIX = <<~SQL.strip_heredoc.freeze
    WITH all_documents AS (
      SELECT entity_id, entity_type, public.to_unaccented_weighted_tsv(title, 'A') AS document, 1 AS priority, 0 AS ranking FROM entities WHERE scope IN ('communities', 'items', 'collections')
      UNION ALL
      SELECT entity_id, entity_type, document, 2 AS priority, ranking AS ranking FROM entity_author_contributions
      UNION ALL
      SELECT entity_id, entity_type, document, 3 AS priority, 1 AS ranking FROM entity_composed_texts
    ), composed_documents AS (
      SELECT
        entity_id,
        entity_type,
        tsvector_agg(document ORDER BY priority ASC, ranking ASC) AS document
      FROM all_documents
      GROUP BY entity_id, entity_type
    ), author_data AS (
      SELECT
        entity_id,
        entity_type,
        jsonb_agg(contributor_name ORDER BY ranking) AS author_names
      FROM entity_author_contributions
      GROUP BY entity_id, entity_type
    ), grouped_schematic_texts AS (
      SELECT
        entity_id,
        entity_type,
        jsonb_object_agg("path", "text_content") AS schematic_texts
        FROM schematic_texts
        GROUP BY 1, 2
    ), search_documents AS (
      SELECT
        entity_id,
        entity_type,
        CASE entity_type
        WHEN 'Community' THEN entity_id
        ELSE NULL
        END AS community_id,
        CASE entity_type
        WHEN 'Collection' THEN entity_id
        ELSE NULL
        END AS collection_id,
        CASE entity_type
        WHEN 'Item' THEN entity_id
        ELSE NULL
        END AS item_id,
        ent.title,
        COALESCE(ad.author_names, '[]'::jsonb) AS author_names,
        COALESCE(gst.schematic_texts, '{}'::jsonb) AS schematic_texts,
        cd.document AS document,
        ent.created_at,
        CURRENT_TIMESTAMP AS updated_at
        FROM entities ent
        INNER JOIN composed_documents cd USING (entity_id, entity_type)
        LEFT OUTER JOIN author_data ad USING (entity_id, entity_type)
        LEFT OUTER JOIN grouped_schematic_texts gst USING (entity_id, entity_type)
        WHERE
          scope IN ('communities', 'collections', 'items')
    SQL

    SUFFIX = <<~SQL.strip_heredoc.freeze
    )
    INSERT INTO entity_search_documents (
      entity_id, entity_type,
      community_id, collection_id, item_id,
      title, author_names, schematic_texts, document,
      created_at, updated_at
    )
    SELECT
      entity_id, entity_type,
      community_id, collection_id, item_id,
      title, author_names, schematic_texts, document,
      created_at, updated_at
    FROM search_documents
    ON CONFLICT (entity_id, entity_type) DO UPDATE SET
      community_id = EXCLUDED.community_id,
      collection_id = EXCLUDED.collection_id,
      item_id = EXCLUDED.item_id,
      title = EXCLUDED.title,
      author_names = EXCLUDED.author_names,
      schematic_texts = EXCLUDED.schematic_texts,
      document = EXCLUDED.document,
      created_at = EXCLUDED.created_at,
      updated_at = EXCLUDED.updated_at
    ;
    SQL

    # @param [HierarchicalEntity] entity
    # @return [Dry::Monads::Success(Integer)]
    def call(entity: nil)
      updated = sql_update! PREFIX, generate_infix_for(entity:), SUFFIX

      Success(updated)
    end

    private

    # Generate an infix to possibly fit between {PREFIX} and {SUFFIX}.
    #
    # @param [String] auth_path
    # @param [Boolean] stale
    # @return [String]
    def generate_infix_for(entity: nil)
      with_quoted_id_for(entity, <<~SQL)
      AND entity_id = %1$s
      SQL
    end
  end
end
