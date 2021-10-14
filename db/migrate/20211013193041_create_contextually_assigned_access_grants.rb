class CreateContextuallyAssignedAccessGrants < ActiveRecord::Migration[6.1]
  def change
    create_view :contextually_assigned_access_grants
  end
end
