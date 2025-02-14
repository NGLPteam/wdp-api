# frozen_string_literal: true

module Support
  module RelayNode
    # Encode an opaque relay ID from a provided model.
    #
    # It allows for encoding the actual type being used in GQL in order to create
    # proper GUIDs for use with Relay caching, even if the underlying models are
    # the same.
    class IdFromObject
      include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)
      include Dry::Monads[:result]
      include Support::Deps[:node_verifier]

      # @param [#to_global_id] object
      # @param [Object] type_definition
      # @param [GraphQL::Query::Context] query_context
      # @return [Dry::Monads::Success(RelayNode::Types::OpaqueID)]
      def call(object, type_definition: nil, query_context: nil, base: nil, type: nil, **metadata)
        base ||= object&.graphql_node_type&.graphql_name

        type ||= type_definition&.graphql_name || base

        global_id = object.to_global_id(**metadata, base:, type:).to_s

        Success node_verifier.generate(global_id, purpose: :node)
      end
    end
  end
end
