# frozen_string_literal: true

module RelayNode
  module Types
    include Dry.Types

    # A type that matches an encoded GlobalID that abstracts the structure and renders it
    # opaque to end users. It is primarily used by GraphQL / Relay as part of the `Node`
    # interface, though it is also sent back from the client for schema properties.
    #
    # @see RelayNode::IdFromObject
    # @see RelayNode::ObjectFromId
    OpaqueID = String.constrained(opaque_id: true)

    # An array of {OpaqueID opaque ids}.
    OpaqueIDList = Array.of(OpaqueID)
  end
end
