# frozen_string_literal: true

module RelayNode
  class IdFromObject
    include Dry::Monads[:result]
    include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)
    include WDPAPI::Deps[:node_verifier]

    def call(object, type_definition: nil, query_context: nil)
      return Failure[:invalid_object, "object does not respond to_global_id"] unless object.respond_to?(:to_global_id)

      global_id = object.to_global_id.to_s

      Success node_verifier.generate(global_id, purpose: :node)
    end
  end
end
