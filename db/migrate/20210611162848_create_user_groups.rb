# frozen_string_literal: true

class CreateUserGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :user_groups, id: :uuid do |t|
      t.uuid    :keycloak_id,   null: true # future-proofing, may expose group adding in keycloak?
      t.citext  :system_slug,   null: false
      t.citext  :name,          null: false
      t.citext  :description,   null: false
      t.jsonb   :metadata,      null: false, default: {}

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index :keycloak_id, unique: true
      t.index :system_slug, unique: true
    end
  end
end
