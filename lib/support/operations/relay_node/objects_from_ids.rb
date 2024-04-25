# frozen_string_literal: true

module Support
  module RelayNode
    # Decode a set of opaque relay IDs and load the associated model(s).
    class ObjectsFromIds
      include Dry::Monads[:result, :list, :do]
      include Support::Deps[
        decode: "relay_node.decode",
        locate_many: "models.locate_many",
      ]

      # @param [<RelayNode::Types::OpaqueID>] ids
      # @param [<Class>]
      # @return [Dry::Monads::Success(<ApplicationRecord>)]
      def call(ids)
        global_ids = yield decode_all! ids

        models = yield locate_many.call global_ids

        Success models
      end

      private

      # @param [<RelayNode::Types::OpaqueID>] ids
      # @return [Dry::Monads::Result]
      def decode_all!(ids)
        results = ids.map { |id| decode.call(id).to_validated }

        List::Validated.coerce(results).traverse.to_result.or do
          Failure[:invalid_opaque_ids]
        end
      end
    end
  end
end
