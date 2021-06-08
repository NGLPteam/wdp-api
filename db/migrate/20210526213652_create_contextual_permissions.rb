class CreateContextualPermissions < ActiveRecord::Migration[6.1]
  def change
    create_view :contextual_permissions
  end
end
