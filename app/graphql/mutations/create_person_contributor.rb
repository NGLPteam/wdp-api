# frozen_string_literal: true

module Mutations
  class CreatePersonContributor < Mutations::BaseMutation
    include Mutations::Shared::PersonContributorArguments

    description "Create a contributor"

    field :contributor, Types::PersonContributorType, null: true, description: "The created person"

    performs_operation! "mutations.operations.create_person_contributor"
  end
end
