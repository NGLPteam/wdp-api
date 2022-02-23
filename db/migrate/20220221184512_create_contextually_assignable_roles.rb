class CreateContextuallyAssignableRoles < ActiveRecord::Migration[6.1]
  def change
    create_view :contextually_assignable_roles
  end
end
