# frozen_string_literal: true

module Types
  class BaseEdge < Types::AbstractObjectType
    # add `node` and `cursor` fields, as well as `node_type(...)` override
    include GraphQL::Types::Relay::EdgeBehaviors

    node_nullable false
  end
end
