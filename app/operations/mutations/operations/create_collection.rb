# frozen_string_literal: true

module Mutations
  module Operations
    # Create a {Collection}.
    #
    # @see Mutations::CreateCollection
    # @see Mutations::Contracts::CreateCollection
    # @see Mutations::Contracts::EntityInput
    # @see Mutations::Contracts::EntityVisibility
    class CreateCollection
      include MutationOperations::Base
      include Mutations::Shared::CreatesEntity

      use_contract! :create_collection
      use_contract! :entity_visibility

      derives_edge! child: :collection, child_source: :static

      def call(parent:, **args)
        authorize parent, :create_collections?

        attributes = args.merge(child_attributes_for(parent))

        collection = Collection.new

        create_entity! collection, **attributes
      end
    end
  end
end
