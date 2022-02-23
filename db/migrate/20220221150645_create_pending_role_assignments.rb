class CreatePendingRoleAssignments < ActiveRecord::Migration[6.1]
  def change
    create_view :pending_role_assignments
  end
end
