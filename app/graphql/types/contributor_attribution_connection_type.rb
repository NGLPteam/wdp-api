# frozen_string_literal: true

module Types
  class ContributorAttributionConnectionType < Types::BaseConnection
    graphql_name "ContributorAttributionConnection"

    edge_type Types::ContributorAttributionEdgeType
  end
end
