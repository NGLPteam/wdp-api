# frozen_string_literal: true

module Users
  # @see UserAccessInfo
  class SynchronizeAccessInfo
    include Dry::Monads[:result]

    # @param [User] user
    # @return [Dry::Monads::Success(void)]
    def call(user)
      return Success(nil) unless user.kind_of?(::User)

      info = user.wrapped_access_info.to_h

      user.update_columns(**info)

      Success user
    end
  end
end
