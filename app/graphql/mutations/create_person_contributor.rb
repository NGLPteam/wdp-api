# frozen_string_literal: true

module Mutations
  class CreatePersonContributor < Mutations::BaseMutation
    description "Create a contributor"

    field :contributor, Types::PersonContributorType, null: true, description: "The created person"

    argument :identifier, String, required: true, description: "A unique identifier for the contributor"

    argument :email, String, required: false, description: "An email associated with the contributor"
    argument :url, String, required: false, description: "The position the community occupies in the list"
    argument :bio, String, required: false, description: "A summary of the contributor"

    argument :given_name, String, required: false
    argument :family_name, String, required: false
    argument :title, String, required: false
    argument :affiliation, String, required: false

    argument :links, [Types::ContributorLinkInputType], required: false

    performs_operation! "mutations.operations.create_person_contributor"
  end
end
