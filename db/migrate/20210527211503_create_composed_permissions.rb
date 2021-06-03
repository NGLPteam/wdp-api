class CreateComposedPermissions < ActiveRecord::Migration[6.1]
  def change
    create_view :composed_permissions
  end
end
