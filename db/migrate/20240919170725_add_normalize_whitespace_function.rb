# frozen_string_literal: true

class AddNormalizeWhitespaceFunction < ActiveRecord::Migration[7.0]
  def up
    execute <<~'SQL'
    CREATE FUNCTION public.normalize_whitespace(text) RETURNS text AS $$
    SELECT TRIM(
      regexp_replace($1, '[\s\u00a0\u180e\u2007\u200b-\u200f\u202f\u2060\ufeff]+', ' ', 'g')
    );
    $$ LANGUAGE SQL IMMUTABLE STRICT PARALLEL SAFE;
    SQL
  end

  def down
    execute <<~SQL
    DROP FUNCTION public.normalize_whitespace(text);
    SQL
  end
end
