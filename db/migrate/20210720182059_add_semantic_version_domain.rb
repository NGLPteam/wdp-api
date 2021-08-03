class AddSemanticVersionDomain < ActiveRecord::Migration[6.1]
  def up
    execute <<~SQL.strip_heredoc.squish
    CREATE DOMAIN semantic_version AS citext
      DEFAULT '0.0.0'
      CONSTRAINT semver_format_applies
        CHECK (VALUE ~ '^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?$')
    ;
    SQL
  end

  def down
    execute <<~SQL
    DROP DOMAIN semantic_version;
    SQL
  end
end
