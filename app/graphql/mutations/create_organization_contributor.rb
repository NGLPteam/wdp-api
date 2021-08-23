# frozen_string_literal: true

module Mutations
  class CreateOrganizationContributor < Mutations::BaseMutation
    description "Create an organization contributor"

    field :contributor, Types::OrganizationContributorType, null: true, description: "The created organization"

    argument :identifier, String, required: true, description: "A unique identifier for the contributor"

    argument :email, String, required: false, description: "An email associated with the contributor"
    argument :url, String, required: false, description: "The position the community occupies in the list"
    argument :bio, String, required: false, description: "A summary of the contributor"

    argument :legal_name, String, required: false
    argument :location, String, required: false

    argument :links, [Types::ContributorLinkInputType], required: false

    performs_operation! "mutations.operations.create_organization_contributor"
  end
end
