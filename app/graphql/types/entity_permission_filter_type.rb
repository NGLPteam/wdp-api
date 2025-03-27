# frozen_string_literal: true

module Types
  class EntityPermissionFilterType < Types::BaseEnum
    description <<~TEXT
    When retrieving lists of entities, sometimes it is helpful to only show
    entities that the current user (or related user) has access to.
    TEXT

    value "SKIP" do
      description <<~TEXT
      A default value that skips checking for access. It will retrieve every
      entity visible to the current user.
      TEXT
    end

    value "READ_ONLY" do
      description <<~TEXT
      Show only the entities that a user has specific read access for—this allows
      them to view the full record as opposed to just what appears in the frontend.
      TEXT
    end

    value "UPDATE" do
      description <<~TEXT
      Show entities that a user has the ability to update.
      TEXT
    end
  end
end
