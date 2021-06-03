class CreateDerivedPermissions < ActiveRecord::Migration[6.1]
  def change
    create_view :derived_permissions
  end
end
