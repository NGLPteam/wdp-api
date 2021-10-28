# frozen_string_literal: true

module Mutations
  class UpdateViewerSettings < Mutations::BaseMutation
    description <<~TEXT
    Update the current viewer (i.e. you).
    TEXT

    field :user, Types::UserType, null: true

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

    performs_operation! "mutations.operations.update_viewer_settings"
  end
end