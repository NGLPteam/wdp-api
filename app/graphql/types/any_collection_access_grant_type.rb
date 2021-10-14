# frozen_string_literal: true

module Types
  class AnyCollectionAccessGrantType < Types::BaseUnion
    possible_types "Types::UserCollectionAccessGrantType", "Types::UserGroupCollectionAccessGrantType"
  end
end
