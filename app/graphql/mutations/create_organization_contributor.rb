# frozen_string_literal: true

module Mutations
  class CreateOrganizationContributor < Mutations::BaseMutation
    include Mutations::Shared::OrganizationContributorArguments

    description "Create an organization contributor"

    field :contributor, Types::OrganizationContributorType, null: true, description: "The created organization"

    performs_operation! "mutations.operations.create_organization_contributor"
  end
end
