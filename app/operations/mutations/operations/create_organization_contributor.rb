# frozen_string_literal: true

module Mutations
  module Operations
    class CreateOrganizationContributor
      include MutationOperations::Base

      use_contract! :create_contributor
      use_contract! :organization_contributor

      def call(links: [], legal_name: nil, location: nil, **args)
        contributor = Contributor.new kind: :organization

        authorize contributor, :create?

        contributor.identifier = SecureRandom.uuid

        attributes = args.compact

        contributor.assign_attributes attributes

        contributor.links = Array(links).map(&:to_h)

        properties = {
          legal_name: legal_name,
          location: location,
        }.compact

        contributor.properties = { organization: properties }

        persist_model! contributor, attach_to: :contributor

        contributor.reload
      end
    end
  end
end
