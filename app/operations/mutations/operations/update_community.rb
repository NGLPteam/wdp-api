# frozen_string_literal: true

module Mutations
  module Operations
    class UpdateCommunity
      include MutationOperations::Base

      def call(community:, **args)
        authorize community, :update?

        attributes = args.slice(:title, :position).compact

        community.assign_attributes attributes

        persist_model! community, attach_to: :community
      end
    end
  end
end
