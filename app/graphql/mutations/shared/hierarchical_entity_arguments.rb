# frozen_string_literal: true

module Mutations
  module Shared
    module HierarchicalEntityArguments
      extend ActiveSupport::Concern

      include Mutations::Shared::EntityArguments

      included do
        argument :accessioned, Types::VariablePrecisionDateInputType, required: false,
          description: "The date this entity was added to its parent",
          attribute: true

        argument :available, Types::VariablePrecisionDateInputType, required: false,
          description: "The date this entity was made available",
          attribute: true

        argument :issued, Types::VariablePrecisionDateInputType, required: false,
          description: "The date this entity was issued",
          attribute: true

        argument :published, Types::VariablePrecisionDateInputType, required: false,
          description: "The date this entity was published",
          attribute: true

        argument :visibility, Types::EntityVisibilityType, required: true,
          description: "What level of visibility the entity has",
          attribute: true

        argument :visible_after_at, GraphQL::Types::ISO8601DateTime, required: false,
          description: "If present, this is the timestamp an entity is visible after",
          attribute: true

        argument :visible_until_at, GraphQL::Types::ISO8601DateTime, required: false,
          description: "If present, this is the timestamp an entity is visible until",
          attribute: true
      end
    end
  end
end
