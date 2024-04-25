# frozen_string_literal: true

module Support
  module RelayNode
    # Decode an opaque relay ID and load the associated model.
    class ObjectFromId
      include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)
      include Dry::Monads[:result]
      include Support::Deps[
        decode: "relay_node.decode",
        find: "models.locate",
      ]

      # @param [RelayNode::Types::OpaqueID] id
      # @param [GraphQL::Query::Context] query_context
      # @return [Dry::Monads::Success(ApplicationRecord)]
      # @return [Dry::Monads::Failure(:not_found, GlobalID)]
      def call(id, query_context: nil)
        decode.call(id).bind do |global_id|
          find.call global_id
        end
      end
    end
  end
end
