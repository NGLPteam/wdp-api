class CreateContextualSinglePermissions < ActiveRecord::Migration[6.1]
  def change
    drop_view :contextual_permissions, revert_to_version: 1

    reversible do |dir|
      change_table :entities do |t|
        dir.up   do
          t.change :entity_type, :text
          t.change :hierarchical_type, :text
        end

        dir.down do
          t.change :entity_type, :string
          t.change :hierarchical_type, :string
        end
      end
    end

    create_view :contextual_permissions, version: 1

    create_view :contextual_single_permissions
  end
end
