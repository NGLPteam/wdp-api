SELECT name, name::text AS key, text2ltree(name::text) AS path, ('*{1}.' || name::text)::lquery AS query FROM unnest(enum_range(NULL::permission_name)) AS t(name);
