# frozen_string_literal: true

module Access
  class CalculateGrantedPermissions
    include Dry::Monads[:do, :result]
    include QueryOperation
    include WDPAPI::Deps[audit: "access.audit_granted_permissions"]

    PREFIX = <<~SQL.squish.strip_heredoc.squish.freeze
    INSERT INTO granted_permissions
    (
      access_grant_id, permission_id, user_id, scope, action, role_id,
      accessible_type, accessible_id, auth_path, inferred, created_at, updated_at
    )
    SELECT ag.id AS access_grant_id,
      p.id AS permission_id,
      ag.user_id AS user_id,
      x.scope,
      p.path AS action,

      ag.role_id AS role_id,
      ag.accessible_type AS accessible_type,
      ag.accessible_id AS accessible_id,

      ag.auth_path,
      rp.inferred AS inferred,

      ag.created_at,
      ag.updated_at
    FROM access_grants ag
    INNER JOIN role_permissions rp USING (role_id)
    INNER JOIN permissions p ON p.id = rp.permission_id
    LEFT JOIN LATERAL (
      SELECT DISTINCT t.scope FROM unnest(p.inheritance) AS t(scope)
    ) x ON true
    SQL

    SUFFIX = <<~SQL.squish.strip_heredoc.squish.freeze
    ON CONFLICT (access_grant_id, permission_id, user_id, scope, action) DO UPDATE SET
      role_id = EXCLUDED.role_id,
      accessible_type = EXCLUDED.accessible_type,
      accessible_id = EXCLUDED.accessible_id,
      auth_path = EXCLUDED.auth_path,
      inferred = EXCLUDED.inferred,
      updated_at = EXCLUDED.updated_at
    SQL

    def call(access_grant: nil, role: nil)
      inserted = sql_insert! PREFIX, generate_infix_for(access_grant: access_grant, role: role), SUFFIX

      deleted = yield audit.call(access_grant: access_grant, role: role)

      Success(inserted: inserted, deleted: deleted)
    end

    private

    def generate_infix_for(access_grant: nil, role: nil)
      ag_id = with_quoted_id_for(access_grant, <<~SQL.squish)
      ag.id = %s
      SQL

      role_id = with_quoted_id_for(role, <<~SQL.squish)
      ag.role_id = %s
      SQL

      conditions = compile_and(ag_id, role_id)

      return "" if conditions.blank?

      with_sql_template(<<~SQL.squish, conditions)
      WHERE %s
      SQL
    end
  end
end
