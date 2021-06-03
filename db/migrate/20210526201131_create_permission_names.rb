class CreatePermissionNames < ActiveRecord::Migration[6.1]
  def change
    create_enum "permission_name", %w[read create update delete manage_access]

    create_view :permission_names, materialized: true

    add_index :permission_names, :name, unique: true
  end
end
