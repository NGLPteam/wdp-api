class AddNameAndAffiliationToContributors < ActiveRecord::Migration[6.1]
  LANG = "SQL".freeze

  def up
    execute <<~SQL
    CREATE FUNCTION derive_contributor_name(kind contributor_kind, properties jsonb) RETURNS text AS $$
    SELECT
      NULLIF(
        TRIM(
          CASE kind
          WHEN 'person' THEN
            CONCAT(
              jsonb_extract_path_text($2, 'person', 'given_name'),
              ' ',
              jsonb_extract_path_text($2, 'person', 'family_name')
            )
          WHEN 'organization' THEN
            jsonb_extract_path_text($2, 'organization', 'legal_name')
          ELSE
            NULL
          END
        ),
        ''
      );
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE FUNCTION derive_contributor_sort_name(kind contributor_kind, properties jsonb) RETURNS citext AS $$
    SELECT
      NULLIF(
        TRIM(
          CASE kind
          WHEN 'person' THEN
            CONCAT_WS(', ',
              NULLIF(TRIM(jsonb_extract_path_text($2, 'person', 'family_name')), ''),
              NULLIF(TRIM(jsonb_extract_path_text($2, 'person', 'given_name')), '')
            )
          WHEN 'organization' THEN
            jsonb_extract_path_text($2, 'organization', 'legal_name')
          ELSE
            NULL
          END
        ),
        ''
      );
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE FUNCTION derive_contributor_affiliation(kind contributor_kind, properties jsonb) RETURNS text AS $$
    SELECT
      NULLIF(
        TRIM(
          CASE kind
          WHEN 'person' THEN
            jsonb_extract_path_text($2, 'person', 'affiliation')
          WHEN 'organization' THEN
            jsonb_extract_path_text($2, 'organization', 'legal_name')
          ELSE
            NULL
          END
        ),
        ''
      );
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    ALTER TABLE contributors
      ADD COLUMN name text GENERATED ALWAYS AS (derive_contributor_name(kind, properties)) STORED,
      ADD COLUMN sort_name citext GENERATED ALWAYS AS (derive_contributor_sort_name(kind, properties)) STORED,
      ADD COLUMN affiliation text GENERATED ALWAYS AS (derive_contributor_affiliation(kind, properties)) STORED
    ;
    SQL

    add_index :contributors, :name
    add_index :contributors, :sort_name
    add_index :contributors, :affiliation
  end

  def down
    remove_column :contributors, :affiliation
    remove_column :contributors, :sort_name
    remove_column :contributors, :name

    execute <<~SQL
    DROP FUNCTION derive_contributor_affiliation(contributor_kind, jsonb);
    DROP FUNCTION derive_contributor_sort_name(contributor_kind, jsonb);
    DROP FUNCTION derive_contributor_name(contributor_kind, jsonb);
    SQL
  end
end
