# frozen_string_literal: true

module Entities
  # Calculate the requisite {AuthorizingEntity} rows for a specific `auth_path` (via {Entity}),
  # based on Entity staleness, or system-wide when passed `auth_path: nil, stale: false`.
  #
  # If an {Entity} is deleted, all rows associated with that specific entity and its children
  # will be removed. However, if a child entity is reparented, it will instead need to be pruned
  # by {Entities::AuditAuthorizing} at a later interval.
  class CalculateAuthorizing
    include Dry::Monads[:do, :result]
    include QueryOperation
    include WDPAPI::Deps[audit: "entities.audit_authorizing"]

    prepend TransactionalCall

    # Insert all child entities for a given `auth_path` in {Entity the entity table}
    # as well as a hierarchical reference to said entity. This can be used to
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

    # If a row already exists, ignore it. {AuthorizingEntity} has no
    # updatable columns.
    SUFFIX = <<~SQL.squish.strip_heredoc.squish.freeze
    GROUP BY 1, 2, 3, 4, 5
    ON CONFLICT (auth_path, entity_id, scope, hierarchical_type, hierarchical_id) DO NOTHING;
    SQL

    # @param [String, nil] auth_path
    # @param [Boolean] stale
    # @return [Dry::Monads::Success(Integer)]
    def call(auth_path: nil, stale: true)
      inserted = sql_insert! PREFIX, generate_infix_for(auth_path: auth_path, stale: stale), SUFFIX

      Success(inserted)
    end

    private

    # Generate an infix to possibly fit between {PREFIX} and {SUFFIX}.
    #
    # @param [String] auth_path
    # @param [Boolean] stale
    # @return [String]
    def generate_infix_for(auth_path: nil, stale: true)
      if auth_path.present?
        with_sql_template(<<~SQL.squish, path: connection.quote(auth_path))
        WHERE ent.auth_path @> %<path>s OR ent.auth_path <@ %<path>s
        SQL
      elsif stale
        with_sql_template <<~SQL
        WHERE ent.stale
        SQL
      else
        ""
      end
    end
  end
end
