class UpdateContextuallyAssignedRolesToVersion2 < ActiveRecord::Migration[6.1]
  def change
    update_view :contextually_assigned_roles, version: 2, revert_to_version: 1
  end
end
