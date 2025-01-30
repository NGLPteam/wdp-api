WITH raw_attributions AS (
  SELECT
    att.id AS attribution_id,
    'CollectionAttribution' AS attribution_type,
    att.contributor_id AS contributor_id,
    att.collection_id AS collection_id,
    NULL::uuid AS item_id,
    att.collection_id AS entity_id,
    'Collection' AS entity_type,
    'collection'::child_entity_kind AS kind,
    ent.title AS title,
    att.created_at,
    att.updated_at
    FROM collection_attributions att
    INNER JOIN collections ent ON ent.id = att.collection_id
  UNION ALL
  SELECT
    att.id AS attribution_id,
    'ItemAttribution' AS attribution_type,
    att.contributor_id AS contributor_id,
    NULL::uuid AS collection_id,
    att.item_id AS item_id,
    att.item_id AS entity_id,
    'Item' AS entity_type,
    'item'::child_entity_kind AS kind,
    ent.title AS title,
    att.created_at,
    att.updated_at
    FROM item_attributions att
    INNER JOIN items ent ON ent.id = att.item_id
), hydrated_attributions AS (
  SELECT
    raw.attribution_id,
    raw.attribution_type,
    raw.contributor_id,
    raw.collection_id,
    raw.item_id,
    raw.entity_id,
    raw.entity_type,
    raw.kind,
    raw.title,
    nvd.value IS NOT NULL AS has_published,
    nvd.normalized AS published,
    nvd.value AS published_on,
    raw.created_at,
    raw.updated_at
    FROM raw_attributions raw
    LEFT OUTER JOIN named_variable_dates nvd USING (entity_id, entity_type)
    WHERE nvd.path = '$published$'
)
SELECT
  att.attribution_id,
  att.attribution_type,
  att.contributor_id,
  att.collection_id,
  att.item_id,
  att.entity_id,
  att.entity_type,
  att.kind,
  att.title,
  att.has_published,
  att.published,
  att.published_on,
  dense_rank() OVER publish_w AS published_rank,
  dense_rank() OVER title_w AS title_rank,
  att.created_at,
  att.updated_at
  FROM hydrated_attributions att
  WINDOW publish_w AS (
    PARTITION BY contributor_id
    ORDER BY COALESCE(att.published_on, att.created_at::date) ASC, att.title ASC, att.created_at ASC
  ), title_w AS (
    PARTITION BY contributor_id
    ORDER BY att.title ASC, att.created_at ASC
  )
