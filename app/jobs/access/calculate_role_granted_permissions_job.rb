# frozen_string_literal: true

module Access
  # Asynchronously calculate {GrantedPermission} for a specific {Role}.
  #
  # @see Access::CalculateGrantedPermissions
  class CalculateRoleGrantedPermissionsJob < ApplicationJob
    include JobIteration::Iteration

    unique :until_and_while_executing, lock_ttl: 3.hours, on_conflict: :log

    queue_as :permissions

    # @param [String] cursor
    # @return [void]
    def build_enumerator(role, cursor:)
      enumerator_builder.active_record_on_records(
        AccessGrant.where(role: role).all,
        cursor: cursor,
      )
    end

    # @param [AccessGrant] access_grant
    # @return [void]
    def each_iteration(access_grant, _role)
      Access::CalculateGrantedPermissionsJob.perform_later access_grant
    end
  end
end
