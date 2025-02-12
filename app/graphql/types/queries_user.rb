# frozen_string_literal: true

module Types
  # @see User
  module QueriesUser
    include Types::BaseInterface

    field :user, Types::UserType, null: true do
      description "Look up a user by slug"

      argument :slug, Types::SlugType, required: true
    end

    field :users, resolver: Resolvers::UserResolver do
      description "A list of all users in the system"
    end

    field :viewer, Types::UserType, null: false do
      description <<~TEXT
      The currently authenticated user. AKA: you
      TEXT
    end

    # @param [String] slug
    # @return [User, nil]
    def user(slug:)
      Support::Loaders::RecordLoader.for(User, column: :keycloak_id).load(slug)
    end

    # @return [User, AnonymousUser]
    def viewer
      context[:current_user] || AnonymousUser.new
    end
  end
end
