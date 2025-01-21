# frozen_string_literal: true

module Mutations
  module Operations
    class UpdateContribution
      include MutationOperations::Base

      def call(contribution:, **attributes)
        authorize contribution, :update?

        attributes.delete(:deprecated_role)

        contribution.assign_attributes attributes

        persist_model! contribution, attach_to: :contribution
      end
    end
  end
end
