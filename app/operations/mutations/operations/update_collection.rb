# frozen_string_literal: true

module Mutations
  module Operations
    class UpdateCollection
      include MutationOperations::Base
      include MutationOperations::UpdatesEntity

      use_contract! :update_collection
      use_contract! :entity_visibility

      def call(collection:, **attributes)
        authorize collection, :update?

        update_entity! collection, attributes
      end
    end
  end
end
