# frozen_string_literal: true

module Types
  class BaseObject < Types::AbstractObjectType
    edge_type_class Types::BaseEdge

    connection_type_class Types::BaseConnection

    field_class Types::BaseField

    class << self
      def use_direct_connection_and_edge!(
        base_name: graphql_name,
        connection_klass_name: "Types::#{base_name}ConnectionType",
        edge_klass_name: "Types::#{base_name}EdgeType"
      )
        @connection_type = connection_klass_name.constantize
        @edge_type = edge_klass_name.constantize
      end
    end
  end
end
