# frozen_string_literal: true

module Support
  module Authorization
    # Normalize simple condition checks to remove logic when it isn't necessary.
    module NormalizesCondition
      module_function

      # @param [(Symbol, Array), (Symbol, (Symbol))] input
      # @return [Symbol]
      # @return [(Symbol, Array)]
      def normalize_condition(input)
        case input
        in Types::ConditionPositiveLogic, Types::SingleCondition => condition
          condition.first
        in Types::ConditionLogic => logic, Types::Conditions => conditions
          [logic, conditions]
        else
          raise InvalidCondition, input
        end
      end
    end
  end
end
