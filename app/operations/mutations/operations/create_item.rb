# frozen_string_literal: true

module Mutations
  module Operations
    class CreateItem
      include MutationOperations::Base
      include Mutations::Shared::AssignsSchemaVersion

      use_contract! :create_item
      use_contract! :entity_input
      use_contract! :entity_visibility

      derives_edge! child: :item, child_source: :static

      def call(parent:, **args)
        authorize parent, :create_items?

        attributes = args.merge(child_attributes_for(parent))

        attributes[:schema_version] = loaded_schema_version

        item = Item.new attributes

        persist_model! item, attach_to: :item
      end
    end
  end
end
