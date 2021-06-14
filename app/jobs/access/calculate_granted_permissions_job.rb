# frozen_string_literal: true

module Access
  # Asynchronously calculate {GrantedPermission} for a specific {AccessGrant}.
  #
  # @see Access::CalculateGrantedPermissions
  class CalculateGrantedPermissionsJob < ApplicationJob
    queue_as :permissions

    # @param [AccessGrant] access_grant
    # @return [void]
    def perform(access_grant)
      WDPAPI::Container["access.calculate_granted_permissions"].call access_grant: access_grant
    end
  end
end
