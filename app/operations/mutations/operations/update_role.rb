# frozen_string_literal: true

module Mutations
  module Operations
    class UpdateRole
      include MutationOperations::Base

      def call(role:, **attributes)
        authorize role, :update?

        role.assign_attributes attributes

        persist_model! role, attach_to: :role
      end
    end
  end
end
