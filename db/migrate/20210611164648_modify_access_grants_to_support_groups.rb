class ModifyAccessGrantsToSupportGroups < ActiveRecord::Migration[6.1]
  def change
    remove_index :access_grants, %i[accessible_id accessible_type user_id], unique: true, name: "index_access_grants_uniqueness"
    remove_index :access_grants, %i[accessible_id accessible_type role_id user_id], unique: true, name: "index_access_grants_role_check"

    change_column_null :access_grants, :user_id, true

    change_table :access_grants do |t|
      t.references :user_group, type: :uuid, null: true, foreign_key: { on_delete: :cascade }
      t.references :subject, type: :uuid, null: true, polymorphic: true

      t.index %i[accessible_type accessible_id subject_type subject_id], unique: true, name: "index_access_grants_uniqueness"
      t.index %i[accessible_type accessible_id role_id subject_type subject_id], unique: true, name: "index_access_grants_role_check"
    end

    reversible do |dir|
      dir.up do
        say_with_time "Populating subject for access grants" do
          execute(<<~SQL.strip_heredoc.squish).cmdtuples
          UPDATE access_grants SET subject_type = 'User', subject_id = user_id;
          SQL
        end
      end

      dir.down do
        say_with_time "Removing group access grants" do
          execute(<<~SQL.strip_heredoc.squish).cmdtuples
          DELETE FROM access_grants WHERE user_group_id IS NOT NULL;
          SQL
        end
      end
    end

    change_column_null :access_grants, :subject_type, false
    change_column_null :access_grants, :subject_id, false
  end
end
