class AddSemanticVersionParsing < ActiveRecord::Migration[6.1]
  LANG = "SQL".freeze

  PATTERN = Base64.decode64(<<~BASE64.strip_heredoc)
  XigwfFsxLTldXGQqKVwuKDB8WzEtOV1cZCopXC4oMHxbMS05XVxkKikoPzot
  KCg/OjB8WzEtOV1cZCp8XGQqW2EtekEtWi1dWzAtOWEtekEtWi1dKikoPzpc
  Lig/OjB8WzEtOV1cZCp8XGQqW2EtekEtWi1dWzAtOWEtekEtWi1dKikpKikp
  Pyg/OlwrKFswLTlhLXpBLVotXSsoPzpcLlswLTlhLXpBLVotXSspKikpPyQ=
  BASE64

  def up
    execute <<~SQL.strip_heredoc.squish
    CREATE TYPE parsed_semver AS (
      major int,
      minor int,
      patch int,
      pre citext,
      build citext
    )
    SQL

    execute <<~SQL.strip_heredoc.squish
    CREATE FUNCTION parse_semver(text) RETURNS parsed_semver AS $$
    SELECT (a[1], a[2], a[3], a[4], a[5])::parsed_semver
    FROM (
      SELECT
      '#{PATTERN}'
      AS pat
    ) p
    LEFT JOIN LATERAL (
      SELECT regexp_matches($1, p.pat) AS a
    ) match ON true
    WHERE match.a IS NOT NULL;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;
    SQL

    execute <<~SQL.strip_heredoc.squish
    ALTER TABLE schema_versions
    ADD COLUMN parsed parsed_semver GENERATED ALWAYS AS (parse_semver(number)) STORED;
    SQL
  end

  def down
    remove_column :schema_versions, :parsed

    execute <<~SQL.strip_heredoc.squish
    DROP FUNCTION parse_semver(text);
    SQL

    execute <<~SQL.strip_heredoc.squish
    DROP TYPE parsed_semver;
    SQL
  end
end
