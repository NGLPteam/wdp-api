class UpdateContextualPermissionsToVersion2 < ActiveRecord::Migration[6.1]
  def change
    update_view :contextual_permissions, version: 2, revert_to_version: 1

    remove_column :access_grants, :auth_query, :lquery
  end
end
