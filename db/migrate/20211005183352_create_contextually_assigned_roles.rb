class CreateContextuallyAssignedRoles < ActiveRecord::Migration[6.1]
  def change
    create_view :contextually_assigned_roles
  end
end
