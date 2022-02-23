class CreatePrimaryRoleAssignments < ActiveRecord::Migration[6.1]
  def change
    add_index :access_grants, %i[subject_id subject_type role_id], name: "index_access_grants_subject_roles"

    create_view :primary_role_assignments
  end
end
