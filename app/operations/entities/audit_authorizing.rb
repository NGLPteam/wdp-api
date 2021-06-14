# frozen_string_literal: true

module Entities
  class AuditAuthorizing
    include Dry::Monads[:result]
    include QueryOperation

    CLEANUP = <<~SQL.squish.strip_heredoc.squish.freeze
    DELETE FROM authorizing_entities ae
    USING
    (
      SELECT DISTINCT ae.auth_path
      FROM authorizing_entities ae
      LEFT OUTER JOIN entities ent USING (auth_path)
      WHERE ent.auth_path IS NULL
    ) missing WHERE missing.auth_path = ae.auth_path
    SQL

    def call
      Success sql_delete! CLEANUP
    end
  end
end
