# frozen_string_literal: true

module Types
  class AnyUserAccessGrantType < Types::BaseUnion
    description <<~TEXT
    Encompasses any access grant for a specific user.
    TEXT

    possible_types "Types::UserCommunityAccessGrantType", "Types::UserCollectionAccessGrantType", "Types::UserItemAccessGrantType"
  end
end
