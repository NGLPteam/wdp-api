# frozen_string_literal: true

module Entities
  class CalculateAuthorizing
    include Dry::Monads[:do, :result]
    include QueryOperation
    include WDPAPI::Deps[audit: "entities.audit_authorizing"]

    PREFIX = <<~SQL.squish.strip_heredoc.squish.freeze
    INSERT INTO authorizing_entities
    (auth_path, entity_id, scope, hierarchical_type, hierarchical_id)
    SELECT
      ent.auth_path AS auth_path,
      subent.id AS entity_id,
      subent.scope,
      subent.hierarchical_type,
      subent.hierarchical_id
      FROM entities ent
      INNER JOIN entities subent ON ent.auth_path @> subent.auth_path
    SQL

    SUFFIX = <<~SQL.squish.strip_heredoc.squish.freeze
    GROUP BY 1, 2, 3, 4, 5
    ON CONFLICT (auth_path, entity_id, scope, hierarchical_type, hierarchical_id) DO NOTHING;
    SQL

    def call(auth_path: nil)
      inserted = sql_insert! PREFIX, generate_infix_for(auth_path: auth_path), SUFFIX

      deleted = yield audit.call

      Success(inserted: inserted, deleted: deleted)
    end

    private

    def generate_infix_for(auth_path: nil)
      return "" if auth_path.blank?

      with_sql_template(<<~SQL.squish, path: connection.quote(auth_path))
      WHERE ent.auth_path @> %<path>s OR ent.auth_path <@ %<path>s
      SQL
    end
  end
end
