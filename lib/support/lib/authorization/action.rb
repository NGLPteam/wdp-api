# frozen_string_literal: true

module Support
  module Authorization
    # A condition that resolves a validated monad for classes that implement
    # {Support::Authorization::DefinesConditions}.
    #
    # @api private
    class Action
      include Support::Authorization::NormalizesCondition

      include Support::Typing

      include Dry::Core::Memoizable

      include Dry::Initializer[undefined: false].define -> do
        param :name, Types::ConditionName

        param :conditions, Types::ConditionList.constrained(min_size: 1)

        option :logic, Types::ConditionLogic, default: proc { :all }
      end

      # @param [Support::Authorization::DefinesConditions] context
      # @return [Dry::Monads::Validated]
      def call(context)
        context.resolve_condition([logic, conditions])
      end

      private

      # @return [Symbol, Array]
      memoize def condition
        normalize_condition [logic, conditions]
      end
    end
  end
end
