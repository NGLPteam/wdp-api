# frozen_string_literal: true

module Mutations
  class UpdateOrganizationContributor < Mutations::BaseMutation
    description "Update an organization contributor"

    field :contributor, Types::OrganizationContributorType, null: true, description: "The updated organization"

    argument :contributor_id, ID, loads: Types::OrganizationContributorType, required: true

    argument :email, String, required: false, description: "An email associated with the contributor"
    argument :url, String, required: false, description: "A url associated with the contributor"
    argument :bio, String, required: false, description: "A summary of the contributor"

    argument :legal_name, String, required: false
    argument :location, String, required: false

    argument :links, [Types::ContributorLinkInputType], required: false

    performs_operation! "mutations.operations.update_organization_contributor"
  end
end
