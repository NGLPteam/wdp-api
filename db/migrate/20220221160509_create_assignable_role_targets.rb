class CreateAssignableRoleTargets < ActiveRecord::Migration[6.1]
  def change
    create_view :assignable_role_targets, materialized: true

    change_table :assignable_role_targets do |t|
      t.index %i[source_role_id target_role_id], unique: true, name: "assignable_role_targets_pkey"
      t.index %i[source_role_id priority target_role_id], name: "index_assignable_role_targets_ordering"
    end
  end
end
