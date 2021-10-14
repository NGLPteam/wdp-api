# frozen_string_literal: true

module Types
  class AnyItemAccessGrantType < Types::BaseUnion
    possible_types "Types::UserItemAccessGrantType", "Types::UserGroupItemAccessGrantType"
  end
end
