# frozen_string_literal: true

# JOIN USING against ltree (or other extension) values does not dump correctly in a way that can be used with an empty search path.
class FixUsingWithLtree < ActiveRecord::Migration[7.0]
  def change
    drop_view :access_grant_management_links, revert_to_version: 1

    update_view :contextual_permissions, version: 4, revert_to_version: 3
    update_view :contextual_single_permissions, version: 2, revert_to_version: 1
    update_view :contextually_assignable_roles, version: 2, revert_to_version: 1
    update_view :contextually_assigned_access_grants, version: 2, revert_to_version: 1
    update_view :contextually_assigned_roles, version: 3, revert_to_version: 2

    create_view :access_grant_management_links, version: 1
  end
end
