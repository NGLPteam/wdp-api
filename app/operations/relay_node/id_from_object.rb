# frozen_string_literal: true

module RelayNode
  # Encode an opaque relay ID from a provided model.
  class IdFromObject
    include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)
    include Dry::Monads[:result]
    include WDPAPI::Deps[:node_verifier]

    # @param [#to_global_id] object
    # @param [Object] type_definition
    # @param [GraphQL::Query::Context] query_context
    # @return [Dry::Monads::Success(RelayNode::Types::OpaqueID)]
    def call(object, type_definition: nil, query_context: nil)
      global_id = object.to_global_id.to_s

      Success node_verifier.generate(global_id, purpose: :node)
    end
  end
end
