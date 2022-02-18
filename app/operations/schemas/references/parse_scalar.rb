# frozen_string_literal: true

module Schemas
  module References
    # This service will normalize received input into a model. It allows our schemas
    # to accept a variety of potentially-valid values of the following types:
    #
    # * {Models::Types::GlobalID a `GlobalID`}
    # * {RelayNodes::Types::OpaqueID an opaque Relay ID}
    # * {ApplicationRecord a single model}
    #
    # @see SchematicScalarReference
    # @see Models::Locate
    # @see RelayNode::ObjectFromId
    class ParseScalar
      include Dry::Monads[:result]
      include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)
      include WDPAPI::Deps[
        locate: "models.locate",
        object_from_id: "relay_node.object_from_id"
      ]

      # @param [Object] value
      # @return [Dry::Monads::Success(ApplicationRecord)]
      # @return [Dry::Monads::Failure(:invalid, Object)]
      def call(value)
        case value
        when Models::Types::GlobalID
          locate.call value
        when RelayNode::Types::OpaqueID
          object_from_id.call value
        when Models::Types::Model
          Success value
        else
          Failure()
        end.or do
          Failure[:invalid, value]
        end
      end
    end
  end
end
