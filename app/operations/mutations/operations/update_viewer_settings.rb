# frozen_string_literal: true

module Mutations
  module Operations
    class UpdateViewerSettings
      include MutationOperations::Base

      include WDPAPI::Deps[
        update_profile: "users.update_profile"
      ]

      attachment! :avatar, image: true

      def call(profile: {}, **args)
        updated = update_profile.call current_user, **profile

        user = with_operation_result! updated

        assign_attributes! user, **args

        persist_model! user, attach_to: :user
      end
    end
  end
end
