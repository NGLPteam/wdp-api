# frozen_string_literal: true

module Mutations
  module Operations
    class UpsertContribution
      include MutationOperations::Base

      def call(contributable:, contributor:, **inputs)
        authorize contributable, :update?

        inputs.delete(:deprecated_role)

        result = contributable.attach_contribution(contributor, **inputs)

        with_attached_result! :contribution, result
      end
    end
  end
end
