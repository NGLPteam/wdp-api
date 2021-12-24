# frozen_string_literal: true

module Mutations
  module Contracts
    # A generic contract for mutations that assign a schema version.
    #
    # @see Mutations::Shared::AssignsSchemaVersion
    class AssignsSchemaVersion < MutationOperations::Contract
      json do
        required(:schema_version_slug).filled(:string)
      end

      rule(:schema_version_slug) do
        key(:schema_version_slug).failure("must correspond to an existing schema") unless has_loaded_schema_version?
      end
    end
  end
end
