# frozen_string_literal: true

module Access
  class AuditGrantedPermissions
    include Dry::Monads[:result]
    include QueryOperation

    CLEANUP = <<~SQL.squish.strip_heredoc.squish.freeze
    DELETE FROM granted_permissions gp
    WHERE id IN (
      SELECT gp.id FROM granted_permissions gp
      LEFT OUTER JOIN role_permissions rp USING (role_id, permission_id)
      WHERE rp.id IS NULL
    )
    SQL

    def call(access_grant: nil, role: nil)
      Success sql_delete! CLEANUP, generate_suffix_for(access_grant: access_grant, role: role)
    end

    private

    def generate_suffix_for(access_grant: nil, role: nil)
      ag_id = with_quoted_id_for(access_grant, <<~SQL.squish)
      gp.access_grant_id = %s
      SQL

      role_id = with_quoted_id_for(role, <<~SQL.squish)
      gp.role_id = %s
      SQL

      conditions = compile_and(ag_id, role_id)

      return "" if conditions.blank?

      with_sql_template(<<~SQL.squish, conditions)
      AND %s
      SQL
    end
  end
end
