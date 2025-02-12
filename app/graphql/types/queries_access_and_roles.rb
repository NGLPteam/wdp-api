# frozen_string_literal: true

module Types
  # An interface for querying {ControlledVocabulary}.
  module QueriesAccessAndRoles
    include Types::BaseInterface

    description <<~TEXT
    An interface for querying information about access control and roles within the system.
    TEXT

    field :access_grants, resolver: Resolvers::AccessGrantResolver do
      description <<~TEXT
      Retrieve all access grants.
      TEXT
    end

    field :roles, resolver: Resolvers::RoleResolver do
      description <<~TEXT
      List all roles.
      TEXT
    end
  end
end
