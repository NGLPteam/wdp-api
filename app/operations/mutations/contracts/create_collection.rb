# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::CreateCollection
    # @see Mutations::Operations::CreateCollection
    class CreateCollection < MutationOperations::Contract
      json do
        required(:parent).filled(Support::GlobalTypes.Instance(::Community) | Support::GlobalTypes.Instance(::Collection))
        required(:schema_version_slug).filled(:string)

        optional(:doi).maybe(:string)
      end

      rule(:doi) do
        key.failure(:must_be_unique_doi) if Collection.has_existing_doi?(values[:doi])
      end

      validate_association_between_parent_and_schema_version!
    end
  end
end
