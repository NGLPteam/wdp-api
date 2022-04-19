# frozen_string_literal: true

module Mutations
  module Operations
    # Create an {Item}.
    #
    # @see Mutations::CreateItem
    # @see Mutations::Contracts::CreateItem
    # @see Mutations::Contracts::EntityInput
    # @see Mutations::Contracts::EntityVisibility
    class CreateItem
      include MutationOperations::Base
      include Mutations::Shared::AssignsSchemaVersion
      include Mutations::Shared::CreatesEntity

      use_contract! :create_item
      use_contract! :entity_visibility

      derives_edge! child: :item, child_source: :static

      def call(parent:, **args)
        authorize parent, :create_items?

        attributes = args.merge(child_attributes_for(parent))

        item = Item.new

        create_entity! item, attributes
      end
    end
  end
end
