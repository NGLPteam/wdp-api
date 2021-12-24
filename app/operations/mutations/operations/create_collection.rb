# frozen_string_literal: true

module Mutations
  module Operations
    class CreateCollection
      include MutationOperations::Base
      include Mutations::Shared::AssignsSchemaVersion

      use_contract! :create_collection
      use_contract! :entity_input
      use_contract! :entity_visibility

      derives_edge! child: :collection, child_source: :static

      def call(parent:, **args)
        authorize parent, :create_collections?

        attributes = args.merge(child_attributes_for(parent))

        attributes[:schema_version] = loaded_schema_version

        collection = Collection.new attributes

        persist_model! collection, attach_to: :collection
      end
    end
  end
end
