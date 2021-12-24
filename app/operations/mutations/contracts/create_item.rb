# frozen_string_literal: true

module Mutations
  module Contracts
    class CreateItem < MutationOperations::Contract
      json do
        required(:parent).filled(AppTypes.Instance(::Collection) | AppTypes.Instance(::Item))
        required(:schema_version_slug).filled(:string)
        optional(:doi).maybe(:string)
      end

      rule(:doi) do
        key.failure(:must_be_unique_doi) if Item.has_existing_doi?(values[:doi])
      end

      validate_association_between_parent_and_schema_version!
    end
  end
end
