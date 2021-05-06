# frozen_string_literal: true

module RelayNode
  class ObjectFromId
    include Dry::Monads[:result]
    include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)
    include WDPAPI::Deps[:node_verifier]

    def call(id, query_context: nil)
      global_id = node_verifier.verify id, purpose: :node

      model = GlobalID.find global_id

      return Failure[:not_found] if model.blank?

      Success model
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      Failure[:invalid_signature, "invalid id"]
    end
  end
end
