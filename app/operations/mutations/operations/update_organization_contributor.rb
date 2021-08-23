# frozen_string_literal: true

module Mutations
  module Operations
    class UpdateOrganizationContributor
      include MutationOperations::Base

      def call(contributor:, links: [], legal_name: nil, location: nil, **args)
        authorize contributor, :update?

        attributes = args.compact

        contributor.assign_attributes attributes

        contributor.links = Array(links).map(&:to_h)

        properties = {
          legal_name: legal_name,
          location: location,
        }.compact

        contributor.properties = { organization: properties }

        persist_model! contributor, attach_to: :contributor
      end

      def validate!(contributor:, **_)
        add_error! "Mismatched contributor type.", path: "contributorId" unless contributor.organization?
      end
    end
  end
end
