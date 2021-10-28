# frozen_string_literal: true

module Mutations
  module Operations
    class CreateCollection
      include MutationOperations::Base
      include AssignsSchemaVersion

      use_contract! :create_collection
      use_contract! :entity_input
      use_contract! :entity_visibility

      def call(parent:, **args)
        authorize parent, :create_collections?

        attributes = args.without(:schema_version_slug)

        attributes[:schema_version] = fetch_found_schema_version!

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
