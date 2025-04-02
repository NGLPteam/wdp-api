# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::UserResetPassword
    # @see Mutations::Operations::UserResetPassword
    class UserResetPassword < MutationOperations::Contract
      json do
        optional(:user).maybe(:user)

        required(:client_id).value(:keycloak_client_id)
        required(:location).value(:client_location)
        required(:redirect_path).value(:redirect_path)
      end
    end
  end
end
