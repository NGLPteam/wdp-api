# frozen_string_literal: true

module Types
  class AccessManagementType < Types::BaseEnum
    description <<~TEXT
    An enum describing the level to which a `User` can manage access on entities within the installation.
    TEXT

    value "GLOBAL", value: "global" do
      description <<~TEXT
      A user has the ability to manage access on all entities in the system.
      TEXT
    end

    value "CONTEXTUAL", value: "contextual" do
      description <<~TEXT
      A user has the ability to manage access to a specific set entities in the system (as well as all their descendants).
      TEXT
    end

    value "FORBIDDEN", value: "forbidden" do
      description <<~TEXT
      A user has no ability to manage access to any entities in the system.
      TEXT
    end
  end
end
