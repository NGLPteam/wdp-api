# frozen_string_literal: true

module Types
  class AnyUserGroupAccessGrantType < Types::BaseUnion
    description <<~TEXT
    Encompasses any access grant for a group of users. Not currently exposed.
    TEXT

    possible_types "Types::UserGroupCommunityAccessGrantType", "Types::UserGroupCollectionAccessGrantType", "Types::UserGroupItemAccessGrantType"
  end
end
