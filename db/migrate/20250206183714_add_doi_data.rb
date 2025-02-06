# frozen_string_literal: true

class AddDOIData < ActiveRecord::Migration[7.0]
  TABLES = %i[collections items].freeze

  LANG = "SQL"

  def change
    reversible do |dir|
      dir.up do
        execute <<~SQL
        CREATE FUNCTION public.extract_doi_from_data(jsonb) RETURNS citext AS $$
        SELECT ($1 ->> 'doi')::citext WHERE $1 @> jsonb_build_object('ok', true);
        $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;
        SQL
      end

      dir.down do
        execute <<~SQL
        DROP FUNCTION IF EXISTS public.extract_doi_from_data(jsonb);
        SQL
      end
    end

    TABLES.each do |table|
      change_table table do |t|
        t.rename :doi, :raw_doi

        t.boolean :has_doi, null: false, default: false

        t.jsonb :doi_data

        t.virtual :doi, type: :citext, null: true, stored: true, as: %[public.extract_doi_from_data(doi_data)]

        t.index :doi
        t.index :has_doi
      end

      reversible do |dir|
        dir.up do
          say_with_time "Migrating existing valid DOIs" do
            exec_update(<<~SQL.strip_heredoc)
            UPDATE #{table} SET
              doi_data = jsonb_build_object(
                'crossref', true,
                'doi', raw_doi,
                'host', 'doi.org',
                'ok', true,
                'url', CONCAT('https://doi.org/', raw_doi)
              ),
              has_doi = TRUE
            WHERE
              raw_doi ~* '^10\\.[0-9]{4,9}/[-._;()/:A-Z0-9]+$'
            ;
            SQL
          end

          say_with_time "Migrating existing weird DOIs" do
            exec_update(<<~SQL.strip_heredoc)
            WITH fixed AS (
              SELECT DISTINCT ON (raw_doi)
                raw_doi AS original_doi,
                regexp_replace(raw_doi, '^(?:https?://)?doi\\.org/(10\\.[0-9]{4,9}/[-._;()/:A-Z0-9]+)$', '\\1', 'i') AS valid_doi
                FROM #{table}
                WHERE raw_doi IS NOT NULL
                AND
                raw_doi !~* '^10\\.[0-9]{4,9}/[-._;()/:A-Z0-9]+$'
                AND
                raw_doi ~* '^(?:https?://)?doi\\.org/(10\\.[0-9]{4,9}/[-._;()/:A-Z0-9]+)$'
            )
            UPDATE #{table} SET
              doi_data = jsonb_build_object(
                'crossref', true,
                'doi', fixed.valid_doi,
                'host', 'doi.org',
                'ok', true,
                'url', CONCAT('https://doi.org/', fixed.valid_doi)
              ),
              has_doi = TRUE
            FROM fixed
            WHERE
              fixed.original_doi <> fixed.valid_doi
              AND
              fixed.original_doi = #{table}.raw_doi
            ;
            SQL
          end
        end

        say_with_time "Populating DOI data otherwise" do
          exec_update(<<~SQL.strip_heredoc)
          UPDATE #{table} SET doi_data = jsonb_build_object('ok', false)
          WHERE doi_data IS NULL;
          SQL
        end
      end

      change_column_null table, :doi_data, false
      change_column_default table, :doi_data, from: nil, to: {}
    end
  end
end
