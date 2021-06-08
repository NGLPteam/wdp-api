# frozen_string_literal: true

module Types
  class PermissionGrantType < Types::BaseObject
    description "A grant of a specific permission within a specific scope"

    field :scope, String, null: true
    field :name, String, null: false
    field :allowed, Boolean, null: false
  end
end
