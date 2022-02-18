# frozen_string_literal: true

module RelayNode
  # Decode an encoded opaque ID into a GlobalID.
  class Decode
    include Dry::Monads[:result]
    include WDPAPI::Deps[:node_verifier]

    # @param [RelayNode::Types::OpaqueID] id
    # @return [Dry::Monads::Success(GlobalID)] a global ID
    # @return [Dry::Monads::Failure(:invalid_signature)]
    # @return [Dry::Monads::Failure(:invalid_global_id)]
    def call(id)
      verified = node_verifier.verify id, purpose: :node

      gid = GlobalID.parse verified

      if gid.present?
        Success gid
      else
        Failure[:invalid_global_id]
      end
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      Failure[:invalid_signature]
    end
  end
end
