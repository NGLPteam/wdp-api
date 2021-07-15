# frozen_string_literal: true

module Mutations
  module Operations
    class CreateCommunity
      include MutationOperations::Base

      def call(**args)
        community = Community.new

        authorize community, :create?

        attributes = args.slice(:title, :position).compact

        community.assign_attributes attributes

        persist_model! community, attach_to: :community
      end
    end
  end
end
