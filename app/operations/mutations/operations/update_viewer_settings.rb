# frozen_string_literal: true

module Mutations
  module Operations
    class UpdateViewerSettings
      include MutationOperations::Base

      include WDPAPI::Deps[
        update_profile: "users.update_profile"
      ]

      def call(avatar: nil, clear_avatar: false, profile: {}, **args)
        updated = update_profile.call current_user, **profile

        user = with_operation_result! updated

        if clear_avatar
          user.avatar = nil
        elsif avatar.present?
          user.avatar = avatar
        end

        persist_model! user, attach_to: :user
      end
    end
  end
end
