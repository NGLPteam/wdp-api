# frozen_string_literal: true

module Support
  module Authorization
    # A type that delegates a condition to another source
    # on the object
    class DelegatedCondition < Support::FlexibleStruct
      attribute :name, Types::ConditionName
      attribute :source, Types::ConditionName
      attribute :klass, Types::Class

      # @param [Support::Authorization::DefinesConditions] context
      # @return [Dry::Monads::Validated]
      def call(context)
        actual_context = context.public_send(source)

        actual_context.resolve_condition(name)
      end
    end
  end
end
