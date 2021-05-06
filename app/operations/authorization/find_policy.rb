# frozen_string_literal: true

module Authorization
  class FindPolicy
    include Dry::Monads[:result]

    # @param [User] user
    # @param [Class, ApplicationRecord] record
    # @return [Dry::Monads::Result(ApplicationPolicy)]
    def call(user, record)
      Success ::Pundit.policy! user, record
    end
  end
end
