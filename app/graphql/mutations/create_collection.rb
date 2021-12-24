# frozen_string_literal: true

module Mutations
  class CreateCollection < Mutations::BaseMutation
    field :collection, Types::CollectionType, null: true

    argument :parent_id, ID, loads: Types::CollectionParentType, required: true do
      description <<~TEXT.strip_heredoc
      The parent of the new collection. This can be the encoded ID of a community or another collection.
      TEXT
    end

    argument :schema_version_slug, String, required: false, transient: true, attribute: true, default_value: "default:collection:latest"

    include Mutations::Shared::CreateHierarchicalEntityArguments
    include Mutations::Shared::AcceptsDOIInput

    performs_operation! "mutations.operations.create_collection"
  end
end
