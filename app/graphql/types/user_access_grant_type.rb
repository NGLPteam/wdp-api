# frozen_string_literal: true

module Types
  module UserAccessGrantType
    include Types::BaseInterface
    include Types::AccessGrantType

    description "An access grant for a user"

    field :user, "Types::UserType", null: false do
      description "The user which has been granted access"
    end
  end
end
