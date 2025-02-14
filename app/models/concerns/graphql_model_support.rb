# frozen_string_literal: true

# Derive GraphQL types by convention, linking an {ApplicationRecord}
# subclass to its corresponding {Types::BaseObject} subclass.
module GraphQLModelSupport
  extend ActiveSupport::Concern

  included do
    extend Dry::Core::ClassAttributes

    defines :graphql_node_type_name, type: Support::Types::String.optional

    delegate :graphql_node_type, :graphql_node_type_name,
      :graphql_connection_type, :graphql_edge_type,
      to: :class
  end

  # Generate a GUID for use with GraphQL / Relay for a persisted model.
  #
  # @see RelayNode::IdFromObject
  # @return [String, nil] the Relay-acc
  def to_encoded_id(...)
    Support::System["relay_node.id_from_object"].(self, ...).value! if persisted?
  end

  module ClassMethods
    # @param [String] slug
    # @raise [ActiveRecord::RecordNotFound]
    # @return [ApplicationRecord]
    def find_graphql_slug(slug)
      id = Common::Container["slugs.decode_id"].call(slug).value!

      find id
    end

    # The connection type to use for this model, derived
    # by default from {.graphql_node_type}.
    #
    # @return [Class, nil]
    def graphql_connection_type
      graphql_node_type&.connection_type
    end

    # The edge type to use for this model, derived
    # by default from {.graphql_node_type}.
    #
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
    # @api private
    # @return [Class, nil]
    def graphql_node_type
      @graphql_node_type ||= graphql_node_type_name.safe_constantize
    end

    # @param [Class] subclass
    # @return [void]
    def inherited(subclass)
      super

      begin
        subclass.graphql_node_type_name "Types::#{subclass.model_name}Type"
      rescue ArgumentError
        # ignore, edge case in tests
      end
    end
  end
end
