# frozen_string_literal: true

module Mutations
  module Shared
    module HierarchicalEntityArguments
      extend ActiveSupport::Concern

      include Mutations::Shared::EntityArguments

      included do
        argument :summary, String, required: false,
          description: "A brief description of the entity's contents.",
          attribute: true
        argument :published, Types::VariablePrecisionDateInputType, required: false,
          description: "The date the entity was published",
          attribute: true
        argument :published_on, GraphQL::Types::ISO8601Date, required: false,
          description: "The date the entity was published",
          deprecation_reason: "Use the variable 'published' input instead",
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
