# frozen_string_literal: true

module Resolvers
  class UserResolver < AbstractResolver
    include Resolvers::Enhancements::AppliesPolicyScope
    include Resolvers::Enhancements::PageBasedPagination
    include Resolvers::OrderedAsUser

    type Types::UserType.connection_type, null: false

    option :prefix, type: String, description: option_description_for(:prefix) do |scope, value|
      scope.apply_prefix value
    end

    scope { User.all }
  end
end
