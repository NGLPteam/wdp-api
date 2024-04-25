# frozen_string_literal: true

module Support
  module Authorization
    # A condition that resolves a validated monad for classes that implement
    # {Support::Authorization::DefinesConditions}.
    #
    # @api private
    class Condition
      include Support::Authorization::NormalizesCondition
      include Support::Typing

      include Dry::Core::Memoizable

      include Dry::Monads[:list, :result, :validated, :do]

      include Dry::Initializer[undefined: false].define -> do
        param :name, Types::ConditionName

        param :resolver, Types::ConditionResolver

        option :from, Types::Dependencies, default: proc { [] }
        option :logic, Types::ConditionLogic, default: proc { :all }
      end

      # @param [Support::Authorization::DefinesConditions] context
      def call(context)
        yield resolve_dependencies_for(context) if from.present?

        is_valid = context.instance_eval(&resolver)

        is_valid ? Valid(name) : Invalid(name)
      end

      private

      # @return [Symbol, Array]
      memoize def dependency_condition
        normalize_condition [logic, from]
      end

      # @return [Dry::Monads::Validated]
      def resolve_dependencies_for(context)
        dependencies = context.resolve_condition(dependency_condition)

        dependencies.alt_map do |failures|
          [*failures, name]
        end
      end
    end
  end
end
