# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users, id: :uuid do |t|
      t.uuid    :keycloak_id,     null: false
      t.boolean :email_verified,  null: false, default: false
      t.citext  :email,           null: false
      t.citext  :username,        null: false
      t.text    :name,            null: false, default: ""
      t.text    :given_name,      null: false, default: ""
      t.text    :family_name,     null: false, default: ""
      t.text    :roles,           null: false, default: [], array: true
      t.jsonb   :metadata,        null: false, default: {}
      t.jsonb   :resource_roles,  null: false, default: {}

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index :keycloak_id, unique: true
    end
  end
end
