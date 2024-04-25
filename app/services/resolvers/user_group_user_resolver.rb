# frozen_string_literal: true

module Resolvers
  class UserGroupUserResolver < AbstractResolver
    include Resolvers::Enhancements::AppliesPolicyScope
    include Resolvers::Enhancements::PageBasedPagination
    include Resolvers::OrderedAsUser

    type Types::UserType.connection_type, null: false

    scope { object.users }
  end
end
