# frozen_string_literal: true

module Mutations
  module Operations
    class ReparentCollection
      include MutationOperations::Base

      def call(parent:, collection:)
        authorize parent, :create_collections?

        attributes = {}

        case parent
        when Community
          attributes[:community] = parent
          attributes[:parent] = nil
        when Collection
          attributes[:community] = parent.community
          attributes[:parent] = parent
        else
          add_error! "Not a valid parent", path: "input.parent"

          return throw_invalid
        end

        collection.assign_attributes attributes

        persist_model! collection, attach_to: :collection
      end

      def validate!(parent:, collection:)
        add_error! "A collection cannot own itself", path: "parent" if parent == collection

        add_error! "A collection cannot be owned by its children", path: "parent" if parent.kind_of?(Collection) && parent.in?(collection.descendants)
      end
    end
  end
end
