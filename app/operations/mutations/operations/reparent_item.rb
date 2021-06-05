# frozen_string_literal: true

module Mutations
  module Operations
    class ReparentItem
      include MutationOperations::Base

      def call(parent:, item:)
        authorize parent, :create_items?

        attributes = {}

        case parent
        when Collection
          attributes[:collection] = parent
          attributes[:parent] = nil
        when Item
          attributes[:collection] = parent.collection
          attributes[:parent] = parent
        else
          add_error! "Not a valid parent", path: "parent"

          return throw_invalid
        end

        item.assign_attributes attributes

        persist_model! item, attach_to: :item
      end

      def validate!(parent:, item:)
        add_error! "An item cannot own itself", path: "parent" if parent == item

        add_error! "An item cannot be owned by its children", path: "parent" if parent.kind_of?(Item) && parent.in?(item.descendants)
      end
    end
  end
end
