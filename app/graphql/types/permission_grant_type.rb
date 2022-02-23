# frozen_string_literal: true

module Types
  # @see Permissions::Grant
  class PermissionGrantType < Types::BaseObject
    description "A grant of a specific permission within a specific scope."

    field :scope, String, null: true do
      description "The scope (or namespace) for this permission."
    end

    field :name, String, null: false do
      description "The unqualified, single name for this permission."
    end

    field :allowed, Boolean, null: false do
      description "Whether this permission has been granted in the current context."
    end

    field :path, String, null: false do
      description "The fully-qualified path for this permission (composed of scope + name)."
    end
  end
end
