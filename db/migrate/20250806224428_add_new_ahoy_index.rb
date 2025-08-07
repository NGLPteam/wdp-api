# frozen_string_literal: true

class AddNewAhoyIndex < ActiveRecord::Migration[7.1]
  def change
    add_index :ahoy_visits, [:visitor_token, :started_at]
  end
end
