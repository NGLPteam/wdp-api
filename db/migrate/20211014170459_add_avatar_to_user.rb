class AddAvatarToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :avatar_data, :jsonb
  end
end
