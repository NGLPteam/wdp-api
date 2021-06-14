# frozen_string_literal: true

module Permissions
  # This task is used to synchronize the {Permission} table so that it can be used for lookups
  # in other parts of the application.
  class Sync
    include Dry::Monads[:result]
    include QueryOperation

    # Calculates the scopes that will inherit a given permission
    # for various entity types that are _not_ self.
    ENTITY_INHERITANCE = <<~SQL.squish.freeze
    WITH contextual AS (
      SELECT * FROM permissions WHERE kind = 'contextual'
    ), bulk AS (
      SELECT path, ARRAY['communities', head] AS inheritance FROM contextual WHERE head <> 'self'
      UNION ALL
      SELECT path, ARRAY['collections'::ltree] AS inheritance FROM contextual WHERE scope <@ 'items'
      UNION ALL
      SELECT path, ARRAY[head || 'linked' || head] AS inheritance FROM contextual WHERE head <> 'self' AND name = 'read'
      UNION ALL
      SELECT path, ARRAY[head || 'linked' || 'items'] AS inheritance FROM contextual WHERE scope <@ 'collections' AND name = 'read'
    ), cmb AS (
      SELECT path, array_accum_distinct(inheritance) AS inheritance
      FROM bulk
      GROUP BY 1
    ) UPDATE permissions p SET inheritance = cmb.inheritance
      FROM cmb WHERE cmb.path = p.path;
    SQL

    # Calculates the scopes that will inherit a given permission
    # for various entity types that are self-directed, which themselves
    # can get inferred by other scope types, e.g. "items.create" becomes "self.create"
    # for child items.
    SELF_INHERITANCE = <<~SQL.squish.freeze
    WITH selfs AS (
    SELECT
      p.id AS permission_id,
      array_accum_distinct(op.inheritance) AS inheritance
      FROM permissions p
      INNER JOIN permissions op USING (kind, suffix)
      WHERE p.kind = 'contextual' AND op.id <> p.id AND p.head = 'self'
      GROUP BY 1
    ) UPDATE permissions p SET inheritance = selfs.inheritance FROM selfs WHERE selfs.permission_id = p.id;
    SQL

    # @return [void]
    def call
      Permission.upsert_all PermissionDefinition.to_sync, unique_by: %i[path]

      sql_insert! ENTITY_INHERITANCE

      sql_insert! SELF_INHERITANCE

      Success(nil)
    end
  end
end
