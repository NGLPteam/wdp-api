# frozen_string_literal: true

class CreateUserAccessInfos < ActiveRecord::Migration[7.0]
  def change
    create_view :user_access_infos

    change_table :users do |t|
      t.enum :access_management, enum_type: "access_management", null: false, default: "forbidden"

      t.boolean :can_manage_access_globally, null: false, default: false
      t.boolean :can_manage_access_contextually, null: false, default: false

      t.index :access_management
    end

    reversible do |dir|
      dir.up do
        say_with_time "Deriving user access info" do
          exec_update(<<~SQL)
          UPDATE users u
            SET access_management = uai.access_management,
                can_manage_access_globally = uai.can_manage_access_globally,
                can_manage_access_contextually = uai.can_manage_access_contextually
            FROM user_access_infos uai
            WHERE uai.user_id = u.id
          SQL
        end
      end
    end
  end
end
