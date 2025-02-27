# frozen_string_literal: true

class CorrectDOIFunction < ActiveRecord::Migration[7.0]
  LANG = "SQL"

  def up
    execute <<~SQL
    CREATE OR REPLACE FUNCTION public.extract_doi_from_data(jsonb) RETURNS citext AS $$
    SELECT ($1 ->> 'doi')::public.citext WHERE $1 @> jsonb_build_object('ok', true);
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;
    SQL
  end

  def down
    # Intentionally left blank
  end
end
