# frozen_string_literal: true

module Resolvers
  class AccessibleCommunityResolver < AbstractResolver
    include Resolvers::FiltersByEntityPermission
    include Resolvers::Enhancements::PageBasedPagination
    include Resolvers::OrderedAsEntity
    include Resolvers::Treelike

    type Types::CommunityType.connection_type, null: false

    scope { Community.all }
  end
end
