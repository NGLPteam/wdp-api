class UpdateContextualPermissionsToVersion3 < ActiveRecord::Migration[6.1]
  def change
    update_view :contextual_permissions, version: 3, revert_to_version: 2
  end
end
