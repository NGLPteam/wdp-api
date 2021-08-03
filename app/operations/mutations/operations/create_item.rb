# frozen_string_literal: true

module Mutations
  module Operations
    class CreateItem
      include MutationOperations::Base
      include AssignsSchemaVersion

      def call(parent:, **args)
        authorize parent, :create_items?

        attributes = args.slice(:title, :identifier)

        attributes[:schema_version] = fetch_found_schema_version!

        case parent
        when Collection
          attributes[:collection] = parent
          attributes[:parent] = nil
        when Item
          attributes[:collection] = parent.collection
          attributes[:parent] = parent
        else
          add_error! "Not a valid parent", path: "input.parent"

          return throw_invalid
        end

        item = Item.new attributes

        persist_model! item, attach_to: :item
      end
    end
  end
end
