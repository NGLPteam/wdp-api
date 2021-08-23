# frozen_string_literal: true

module Mutations
  module Operations
    class UpdatePersonContributor
      include MutationOperations::Base

      def call(contributor:, links: [], given_name: nil, family_name: nil, title: nil, affiliation: nil, **args)
        authorize contributor, :update?

        attributes = args.compact

        contributor.assign_attributes attributes

        contributor.links = Array(links).map(&:to_h)

        properties = {
          given_name: given_name,
          family_name: family_name,
          title: title,
          affiliation: affiliation,
        }.compact

        contributor.properties = { person: properties }

        persist_model! contributor, attach_to: :contributor
      end

      def validate!(contributor:, **_)
        add_error! "Mismatched contributor type.", path: "contributorId" unless contributor.person?
      end
    end
  end
end
