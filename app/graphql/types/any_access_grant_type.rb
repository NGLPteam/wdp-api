# frozen_string_literal: true

module Types
  class AnyAccessGrantType < Types::BaseUnion
    description <<~TEXT
    Encompasses *all* possible access grant types
    TEXT

    possible_types "Types::UserCommunityAccessGrantType", "Types::UserCollectionAccessGrantType", "Types::UserItemAccessGrantType",
      "Types::UserGroupCommunityAccessGrantType", "Types::UserGroupCollectionAccessGrantType", "Types::UserGroupItemAccessGrantType"
  end
end
