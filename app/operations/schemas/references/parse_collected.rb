# frozen_string_literal: true

module Schemas
  module References
    # This service is like its {Schemas::References::ParseScalar scalar equivalent},
    # except that it is designed to work with and return an _array_ of referenced models.
    #
    # * an array of models
    # * an array of opaque Relay IDs
    # * an array of GlobalIDs
    #
    # Given a single (or `nil`) input, it will always return an array.
    #
    # @see SchematicCollectedReference
    # @see Models::Types::GlobalID
    # @see RelayNode::ObjectFromId
    class ParseCollected
      include Dry::Monads[:result]
      include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)
      include WDPAPI::Deps[
        locate_many: "models.locate_many",
        objects_from_ids: "relay_node.objects_from_ids"
      ]

      # @param [Array] input
      # @return [Dry::Monads::Result<ApplicationRecord>]
      def call(input)
        values = cast input

        return Success(values) if values.empty?

        case values
        when Models::Types::GlobalIDList
          locate_many.call values
        when RelayNode::Types::OpaqueIDList
          objects_from_ids.call values
        when Models::Types::ModelList
          Success values
        else
          Failure()
        end.or do
          Failure[:invalid, values]
        end
      end

      private

      # @param [Array, Object, nil] input
      # @return [Array]
      def cast(input)
        return [] if input.nil?

        input.kind_of?(Array) ? input : [input]
      end
    end
  end
end
