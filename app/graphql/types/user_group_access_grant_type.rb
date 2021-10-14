# frozen_string_literal: true

module Types
  module UserGroupAccessGrantType
    include Types::BaseInterface
    include Types::AccessGrantType

    description "An access grant for a user group"

    field :user_group, "Types::UserGroupType", null: false do
      description "The group which has been granted access"
    end
  end
end
