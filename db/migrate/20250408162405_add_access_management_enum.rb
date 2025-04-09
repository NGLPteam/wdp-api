# frozen_string_literal: true

class AddAccessManagementEnum < ActiveRecord::Migration[7.0]
  def change
    create_enum "access_management", %w[global contextual forbidden]
  end
end
