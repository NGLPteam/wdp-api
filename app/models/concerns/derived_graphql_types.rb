# frozen_string_literal: true

# Derive GraphQL types by convention, linking an {ApplicationRecord}
# subclass to its corresponding {Types::BaseObject} subclass.
module DerivedGraphqlTypes
  extend ActiveSupport::Concern

  included do
    delegate :graphql_node_type, :graphql_node_type_name,
      to: :class
  end

  # @return [Class, nil]
  def graphql_connection_type
    graphql_node_type&.connection_type
  end

  # @return [Class, nil]
  def graphql_edge_type
    graphql_node_type&.edge_type
  end

  module ClassMethods
    # @return [Class, nil]
    def graphql_connection_type
      graphql_node_type&.connection_type
    end

    # @return [Class, nil]
    def graphql_edge_type
      graphql_node_type&.edge_type
    end

    # The corresponding object type for this model in the GraphQL API.
    #
    # Derived from {.graphql_node_type_name}.
    #
    # Used to possibly derive {.graphql_connection_type} and {.graphql_edge_type}.
    #
    # @return [Class, nil]
    def graphql_node_type
      @graphql_node_type ||= graphql_node_type_name.safe_constantize
    end

    # Overridable type used to derive {.graphql_node_type}.
    # @return [String]
    def graphql_node_type_name
      @graphql_node_type_name ||= "Types::#{model_name}Type"
    end
  end
end
