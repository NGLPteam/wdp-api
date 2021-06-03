WITH RECURSIVE collection_paths(community_id, collection_id, auth_path) AS (
  SELECT coll.community_id, coll.id AS collection_id, comm.auth_path || text2ltree(coll.system_slug) AS auth_path
  FROM collections coll
  INNER JOIN communities comm ON comm.id = coll.community_id
  WHERE coll.parent_id IS NULL
  UNION ALL
  SELECT coll.community_id, coll.id AS collection_id, ct.auth_path || text2ltree(coll.system_slug) AS auth_path
  FROM collections coll
  INNER JOIN collection_paths ct ON ct.collection_id = coll.parent_id
), item_paths(community_id, collection_id, item_id, auth_path) AS (
  SELECT coll.community_id, i.collection_id, i.id AS item_id, coll.auth_path || text2ltree(i.system_slug) AS auth_path
  FROM items i
  INNER JOIN collection_paths coll USING (collection_id)
  WHERE i.parent_id IS NULL
  UNION ALL
  SELECT coll.community_id, i.collection_id, i.id AS item_id, ip.auth_path || text2ltree(i.system_slug) AS auth_path
  FROM items i
  INNER JOIN collection_paths coll USING (collection_id)
  INNER JOIN item_paths ip ON ip.item_id = i.parent_id
)
SELECT * FROM item_paths;
