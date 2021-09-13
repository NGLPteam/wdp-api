# frozen_string_literal: true

module Mutations
  module Operations
    class CreateCommunity
      include MutationOperations::Base
      include AssignsSchemaVersion

      use_contract! :entity_input

      def call(**args)
        community = Community.new

        authorize community, :create?

        attributes = args.without(:schema_version_slug)

        attributes[:schema_version] = fetch_found_schema_version!

        community.assign_attributes attributes

        persist_model! community, attach_to: :community
      end
    end
  end
end
