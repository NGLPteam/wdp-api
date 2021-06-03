WITH RECURSIVE closure_tree(community_id, collection_id, auth_path) AS (
  SELECT coll.community_id, coll.id AS collection_id, comm.auth_path || text2ltree(coll.system_slug) AS auth_path
  FROM collections coll
  INNER JOIN communities comm ON comm.id = coll.community_id
  WHERE coll.parent_id IS NULL
  UNION ALL
  SELECT coll.community_id, coll.id AS collection_id, ct.auth_path || text2ltree(coll.system_slug) AS auth_path
  FROM collections coll
  INNER JOIN closure_tree ct ON ct.collection_id = coll.parent_id
)
SELECT * FROM closure_tree;
