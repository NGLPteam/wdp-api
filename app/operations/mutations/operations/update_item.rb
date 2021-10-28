# frozen_string_literal: true

module Mutations
  module Operations
    class UpdateItem
      include MutationOperations::Base
      include MutationOperations::UpdatesEntity

      use_contract! :update_item
      use_contract! :entity_visibility

      def call(item:, **attributes)
        authorize item, :update?

        update_entity! item, attributes
      end
    end
  end
end
