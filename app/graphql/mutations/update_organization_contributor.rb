# frozen_string_literal: true

module Mutations
  class UpdateOrganizationContributor < Mutations::BaseMutation
    include Mutations::Shared::OrganizationContributorArguments

    description "Update an organization contributor"

    field :contributor, Types::OrganizationContributorType, null: true, description: "The updated organization"

    argument :contributor_id, ID, loads: Types::OrganizationContributorType, required: true

    clearable_attachment! :image

    performs_operation! "mutations.operations.update_organization_contributor"
  end
end
