# frozen_string_literal: true

module Mutations
  module Operations
    class CreateCollection
      include MutationOperations::Base

      def call(parent:, **args)
        attributes = args.slice(:title, :identifier)

        attributes[:schema_definition] = SchemaDefinition.default_collection

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

        collection = Collection.new attributes

        persist_model! collection, attach_to: :collection
      end
    end
  end
end
