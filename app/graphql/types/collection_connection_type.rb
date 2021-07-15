# frozen_string_literal: true

module Types
  class CollectionConnectionType < Types::BaseConnection
    graphql_name "CollectionConnection"

    edge_type Types::CollectionEdgeType
  end
end
