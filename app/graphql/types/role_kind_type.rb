# frozen_string_literal: true

module Types
  class RoleKindType < Types::BaseEnum
    description <<~TEXT
    A categorization of a `Role` based on how it gets into the WDP-API.
    TEXT

    value "CUSTOM", value: "custom" do
      description <<~TEXT
      Custom roles are created and managed through the `createRole`, `updateRole`, and `destroyRole` mutations.
      TEXT
    end

    value "SYSTEM", value: "system" do
      description <<~TEXT
      System roles are shipped by default with WDP-API and cannot be modified.
      TEXT
    end
  end
end
