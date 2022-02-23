# frozen_string_literal: true

module Types
  # @see Role
  # @see SystemRole
  class RoleSystemIdentifierType < Types::BaseEnum
    description <<~TEXT
    This will identify _which_ `system` role this is, if applicable. See `RoleKind` for more information.
    TEXT

    value "ADMIN", value: "admin" do
      description <<~TEXT
      A global administrator. This role cannot be directly assigned.
      TEXT
    end

    value "MANAGER", value: "manager" do
      description <<~TEXT
      A manager can be assigned to handle most `Community` and other entity management concerns.

      They can also appoint other roles (except for other managers) to any entity they manage.
      TEXT
    end

    value "EDITOR", value: "editor" do
      description <<~TEXT
      An editor has basic update permissions for a specific point in the hierarchy.
      TEXT
    end

    value "READER", value: "reader" do
      description <<~TEXT
      A reader is anyone who has been given explicit read-access to an entity.
      This role is primarily used by the administration UI.

      **Note**: Anonymous users can still view public entities in the frontend.
      TEXT
    end
  end
end
