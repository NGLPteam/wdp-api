# frozen_string_literal: true

module Users
  class NormalizeTesting
    include Dry::Monads[:do, :result]
    include WDPAPI::Deps[
      encode_id: "slugs.encode_id",
    ]
    include MonadicPersistence

    def call(user)
      return Failure[:non_testing, "User is not a testing user"] unless user.testing?

      encoded = yield encode_id.call(user.id)

      user.email = "user.#{encoded}@example.com"
      user.username = "user.#{encoded}@example.com"

      monadic_save user
    end
  end
end
