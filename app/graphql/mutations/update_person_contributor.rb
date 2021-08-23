# frozen_string_literal: true

module Mutations
  class UpdatePersonContributor < Mutations::BaseMutation
    description "Update a person contributor"

    field :contributor, Types::PersonContributorType, null: true, description: "The created person"

    argument :contributor_id, ID, loads: Types::PersonContributorType, required: true

    argument :email, String, required: false, description: "An email associated with the contributor"
    argument :url, String, required: false, description: "The position the community occupies in the list"
    argument :bio, String, required: false, description: "A summary of the contributor"

    argument :given_name, String, required: false
    argument :family_name, String, required: false
    argument :title, String, required: false
    argument :affiliation, String, required: false

    argument :links, [Types::ContributorLinkInputType], required: false

    performs_operation! "mutations.operations.update_person_contributor"
  end
end
