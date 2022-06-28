SELECT DISTINCT ON (c.id) c.id AS collection_id, c.community_id AS invalid_community_id, anc.community_id AS valid_community_id
FROM collections AS c
INNER JOIN collection_hierarchies AS hier ON hier.descendant_id = c.id
INNER JOIN collections AS anc ON hier.ancestor_id = anc.id
WHERE c.parent_id IS NOT NULL AND anc.community_id <> c.community_id
ORDER BY c.id ASC, hier.generations DESC
