# frozen_string_literal: true

module Authorization
  class Authorize
    include Dry::Monads[:do, :result]
    include WDPAPI::Deps[find_policy: "authorization.find_policy"]

    def call(user, record, action, policy_class: nil)
      policy = policy_class ? policy_class.new(user, record) : yield(find_policy.call(user, record))

      return Failure[:unknown_action, "Cannot authorize #{action} on #{policy.class.name}"] unless policy.respond_to?(action)

      return Failure[:unauthorized, "User##{user.id} cannot #{policy.class.name}##{action}"] unless policy.public_send(action)

      Success record
    end
  end
end
