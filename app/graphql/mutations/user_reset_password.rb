# frozen_string_literal: true

module Mutations
  # @see Mutations::Operations::UserResetPassword
  class UserResetPassword < Mutations::BaseMutation
    description <<~TEXT
    Reset a password for the current or specified user
    TEXT

    field :success, Boolean, null: true do
      description <<~TEXT
      Whether or not instructions were successfully sent.
      TEXT
    end

    field :user, ::Types::UserType, null: true do
      description <<~TEXT
      The user whose password was reset. Handy for showing the email that it was sent to.
      TEXT
    end

    argument :user_id, ID, loads: Types::UserType, required: false do
      description <<~TEXT
      Specify a user to send reset password instructions for.

      If left blank, it will send reset password instructions for the current user.
      TEXT
    end

    argument :client_id, String, required: true do
      description <<~TEXT
      The keycloak client used to authenticate users associated with the current `location`.

      Must be provided.
      TEXT
    end

    argument :location, ::Types::ClientLocationType, required: true do
      description <<~TEXT
      Which location the user should be sent back to once completing
      the reset password flow.

      It is used in concert with `redirectPath` in order to build the
      actual URL.
      TEXT
    end

    argument :redirect_path, String, required: true do
      description <<~TEXT
      The redirect path on the `location` to redirect the user to.

      Must be a **relative** URI like `"/foo/bar/baz"`. `"/"` is the minimum acceptable.
      TEXT
    end

    performs_operation! "mutations.operations.user_reset_password"
  end
end
