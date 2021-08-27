# frozen_string_literal: true

module Mutations
  class UpdatePersonContributor < Mutations::BaseMutation
    include Mutations::Shared::PersonContributorArguments

    description "Update a person contributor"

    field :contributor, Types::PersonContributorType, null: true, description: "The created person"

    argument :contributor_id, ID, loads: Types::PersonContributorType, required: true

    clearable_attachment! :image

    performs_operation! "mutations.operations.update_person_contributor"
  end
end
