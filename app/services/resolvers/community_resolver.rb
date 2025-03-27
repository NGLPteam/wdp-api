# frozen_string_literal: true

module Resolvers
  class CommunityResolver < AbstractResolver
    include Resolvers::Enhancements::AppliesPolicyScope
    include Resolvers::Enhancements::PageBasedPagination
    include Resolvers::FiltersByEntityPermission
    include Resolvers::OrderedAsEntity

    type Types::CommunityType.connection_type, null: false

    scope { Community.all }
  end
end
