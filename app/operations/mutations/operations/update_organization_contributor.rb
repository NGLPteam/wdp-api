# frozen_string_literal: true

module Mutations
  module Operations
    class UpdateOrganizationContributor
      include MutationOperations::Base

      use_contract! :update_contributor
      use_contract! :organization_contributor

      attachment! :image, image: true

      def call(contributor:, links: [], legal_name: nil, location: nil, **args)
        authorize contributor, :update?

        contributor.links = Array(links).map(&:to_h)

        assign_attributes! contributor, **args

        properties = {
          legal_name:,
          location:,
        }.compact

        contributor.properties = { organization: properties }

        persist_model! contributor, attach_to: :contributor
      end

      def validate!
        args => { contributor: }

        add_error! "Mismatched contributor type.", path: "contributorId" unless contributor.organization?
      end
    end
  end
end
