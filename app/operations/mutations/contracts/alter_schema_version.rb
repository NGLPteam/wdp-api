# frozen_string_literal: true

module Mutations
  module Contracts
    # A generic contract for mutations that assign a schema version.
    #
    # @see Mutations::Operations::AlterSchemaVersion
    class AlterSchemaVersion < MutationOperations::Contract
      json do
        required(:entity).filled(AppTypes.Instance(HasSchemaDefinition))
        required(:schema_version_slug).filled(:string)
      end

      validate_association_between_contextual_parent_and_new_schema_version!
    end
  end
end
