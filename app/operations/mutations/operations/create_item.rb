# frozen_string_literal: true

module Mutations
  module Operations
    class CreateItem
      include MutationOperations::Base

      def call(parent:, **args)
        attributes = args.slice(:title, :identifier)

        attributes[:schema_definition] = SchemaDefinition.default_item

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
