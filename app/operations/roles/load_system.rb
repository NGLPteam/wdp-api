# frozen_string_literal: true

module Roles
  # Upsert the {SystemRole} definitions.
  class LoadSystem
    include Dry::Monads[:result, :do]
    include QueryOperation
    include WDPAPI::Deps[
      calculate_role_permissions: "roles.calculate_role_permissions"
    ]

    PREFIX = <<~SQL
    INSERT INTO roles (identifier, name, access_control_list, global_access_control_list)
    SQL

    SUFFIX = <<~SQL
    ON CONFLICT (identifier) DO UPDATE SET
      name = EXCLUDED.name,
      access_control_list = EXCLUDED.access_control_list,
      global_access_control_list = EXCLUDED.global_access_control_list
    RETURNING id
    SQL

    # @return [Dry::Monads::Result]
    def call
      values = ::SystemRole.to_values_list(:identifier, :name, :access_control_list, :global_access_control_list).to_sql

      inserted = sql_insert! PREFIX, values, SUFFIX

      role_ids = inserted.pluck "id"

      Role.where(id: role_ids).find_each do |role|
        yield calculate_role_permissions.call role: role
      end

      AssignableRoleTarget.refresh!

      Success(role_ids)
    end
  end
end
