# frozen_string_literal: true

module Support
  module RelayNode
    class TypeFromModel
      include Dry::Monads[:result]

      # @param [ApplicationRecord] object
      # @return [Dry::Monads::Result(Class)]
      def call(object)
        return Failure[:invalid_model, "#{object.inspect} is not a model"] unless object.kind_of?(ApplicationRecord)

        maybe_type = object.graphql_node_type

        Support::GlobalTypes::GraphQLTypeClass.try(maybe_type).to_monad.or do
          Failure[:undefined_type, "#{object.model_name} has no associated GraphQL type"] if maybe_type
        end
      end
    end
  end
end
