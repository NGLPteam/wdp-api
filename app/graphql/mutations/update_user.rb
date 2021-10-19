# frozen_string_literal: true

module Mutations
  class UpdateUser < Mutations::BaseMutation
    description <<~TEXT
    Update a user.
    TEXT

    field :user, Types::UserType, null: true

    argument :user_id, ID, loads: Types::UserType, required: true

    argument :avatar, Types::UploadedFileInputType, required: false, attribute: true do
      description <<~TEXT.strip_heredoc
      An avatar to represent your user in the WDP.
      TEXT
    end

    clearable_attachment! :avatar

    argument :profile, Types::UserProfileInputType, required: true, attribute: true do
      description <<~TEXT.strip_heredoc
      Attributes for the user that correspond to attributes in Keycloak.
      TEXT
    end

    performs_operation! "mutations.operations.update_user"
  end
end
