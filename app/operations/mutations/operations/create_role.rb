# frozen_string_literal: true

module Mutations
  module Operations
    class CreateRole
      include MutationOperations::Base

      def call(name:, access_control_list:)
        attributes = { name: name, access_control_list: access_control_list }

        role = Role.new attributes

        authorize role, :create?

        persist_model! role, attach_to: :role
      end
    end
  end
end
