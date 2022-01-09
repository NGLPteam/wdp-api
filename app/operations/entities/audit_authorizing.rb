# frozen_string_literal: true

module Entities
  # If a child entity is moved or deleted, it's not guaranteed to be removed
  # from the {AuthorizingEntity authorizing table} because we do not have
  # FK associations set up. It's not an immediate priority to remove rows
  # from this, so it runs in a scheduled task
  #
  # @see Entities::AuditAuthorizingJob
  class AuditAuthorizing
    include Dry::Monads[:result]
    include QueryOperation

    # Select all distinct `auth_path` values in {AuthorizingEntity}, that
    # do not have a corresponding row in {Entity}, then delete them.
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

    # @return [Dry::Monads::Success(Integer)]
    def call
      Success sql_delete! CLEANUP
    end
  end
end
