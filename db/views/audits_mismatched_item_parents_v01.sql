SELECT DISTINCT ON (c.id) c.id AS item_id, c.collection_id AS invalid_collection_id, anc.collection_id AS valid_collection_id
FROM items AS c
INNER JOIN item_hierarchies AS hier ON hier.descendant_id = c.id
INNER JOIN items AS anc ON hier.ancestor_id = anc.id
WHERE c.parent_id IS NOT NULL AND anc.collection_id <> c.collection_id
ORDER BY c.id ASC, hier.generations DESC
