# frozen_string_literal: true

module Types
  class ItemConnectionType < Types::BaseConnection
    graphql_name "ItemConnection"

    edge_type Types::ItemEdgeType
  end
end
