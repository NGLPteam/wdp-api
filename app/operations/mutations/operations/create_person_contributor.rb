# frozen_string_literal: true

module Mutations
  module Operations
    class CreatePersonContributor
      include MutationOperations::Base

      use_contract! :person_contributor

      def call(links: [], given_name: nil, family_name: nil, title: nil, affiliation: nil, **args)
        contributor = Contributor.new kind: :person

        authorize contributor, :create?

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
    end
  end
end
