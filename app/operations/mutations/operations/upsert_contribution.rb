# frozen_string_literal: true

module Mutations
  module Operations
    class UpsertContribution
      include MutationOperations::Base

      def call(contributable:, contributor:, **inputs)
        authorize contributable, :update?

        klass, attributes, unique_by = contributable.for_upsert_contribution_mutation(contributor: contributor)

        # Currently aliased
        attributes[:kind] = inputs[:role] if inputs.key?(:role)
        attributes[:metadata] = inputs[:metadata] if inputs[:metadata].present?

        upsert_model! klass, attributes, unique_by: unique_by, attach_to: :contribution
      end
    end
  end
end
