# frozen_string_literal: true

module Mutations
  module Operations
    class CreateCommunity
      include MutationOperations::Base
      include Mutations::Shared::AssignsSchemaVersion

      use_contract! :entity_input

      def call(**args)
        community = Community.new

        authorize community, :create?

        attributes = args

        attributes[:schema_version] = loaded_schema_version

        community.assign_attributes attributes

        persist_model! community, attach_to: :community
      end
    end
  end
end
