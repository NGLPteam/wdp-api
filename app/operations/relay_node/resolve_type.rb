# frozen_string_literal: true

module RelayNode
  class ResolveType
    include Dry::Monads[:do, :result]
    include WDPAPI::Deps[type_from_model: "relay_node.type_from_model"]

    # @param [Object] object
    # @param [GraphQL::BaseType] abstract_type
    # @param [GraphQL::Query::Context] context
    # @return [Dry::Monads::Result(Class)]
    def call(object, abstract_type, context)
      case object
      when ApplicationRecord
        type_from_model.call(object)
      when GraphQL::Relay::Edge
        type_from_model.call(object.node).bind do |node_type|
          edge = node_type&.edge_type

          edge ? Success(edge) : Failure("Unexpected edge type: #{object.inspect}")
        end
      when GraphQL::ExecutionError
        Failure(object)
      else
        Failure(false)
      end
    end
  end
end
