WITH raw_contributions AS (
  SELECT
    id AS contribution_id,
    'CollectionContribution' AS contribution_type,
    collection_id AS entity_id,
    'Collection' AS entity_type,
    contributor_id,
    inner_position,
    outer_position,
    created_at,
    updated_at
    FROM collection_contributions
    WHERE
    "collection_contributions"."role_id" IN (SELECT "controlled_vocabulary_items"."id" FROM "controlled_vocabulary_items" WHERE 'author' = ANY("controlled_vocabulary_items"."tags"))
  UNION ALL
  SELECT
    id AS contribution_id,
    'ItemContribution' AS contribution_type,
    item_id AS entity_id,
    'Item' AS entity_type,
    contributor_id,
    inner_position,
    outer_position,
    created_at,
    updated_at
    FROM item_contributions
    WHERE
    "item_contributions"."role_id" IN (SELECT "controlled_vocabulary_items"."id" FROM "controlled_vocabulary_items" WHERE 'author' = ANY("controlled_vocabulary_items"."tags"))
)
SELECT DISTINCT ON (entity_id, contributor_id)
  rc.contribution_id,
  rc.contribution_type,
  rc.entity_id,
  rc.entity_type,
  rc.contributor_id,
  rc.inner_position,
  rc.outer_position,
  dense_rank() OVER w AS ranking,
  c.name AS contributor_name,
  c.sort_name AS contributor_sort_name,
  public.to_unaccented_weighted_tsv(c.name, 'B') AS document,
  rc.created_at,
  rc.updated_at
FROM raw_contributions rc
INNER JOIN contributors c ON c.id = rc.contributor_id
WINDOW w AS (
  PARTITION BY rc.entity_id
  ORDER BY rc.outer_position ASC NULLS LAST, rc.inner_position ASC NULLS LAST, c.sort_name ASC
)
