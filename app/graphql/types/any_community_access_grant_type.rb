# frozen_string_literal: true

module Types
  class AnyCommunityAccessGrantType < Types::BaseUnion
    possible_types "Types::UserCommunityAccessGrantType", "Types::UserGroupCommunityAccessGrantType"
  end
end
