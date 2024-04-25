# frozen_string_literal: true

module Support
  module Authorization
    # Define boolean conditions that must be met in order to satisfy authorization actions.
    module DefinesConditions
      extend ActiveSupport::Concern

      include Dry::Monads[:list, :validated, :result]

      ConditionResolution = Support::Authorization::Condition::Type | Support::Authorization::DelegatedCondition

      ConditionMapping = Types::Hash.map(Types::ConditionName, ConditionResolution)

      ConditionSource = Types::Class.constrained(lt: self)

      FLATTEN_CONDITIONS = proc { _1.to_a.flatten }

      included do
        extend Dry::Core::ClassAttributes

        extend Support::TypedSet.of(Types::ConditionName)[:conditions]

        defines :condition_mapping, type: ConditionMapping

        condition_mapping({}.freeze)
      end

      # @param [(:and, ConditionList), (:any, ConditionList), (:not, ConditionName), ConditionName] condition
      # @return [Dry::Monads::Validated]
      def resolve_condition(condition)
        case condition
        in :all, Array => conditions
          resolve_all_conditions(conditions)
        in :any, Array => conditions
          resolve_any_conditions(conditions)
        in :nor, Array => conditions
          resolve_nor_conditions(conditions)
        in :not, Array => conditions
          resolve_not_conditions(conditions)
        in Types::ConditionName => condition_name
          resolve_single_condition(condition_name)
        else
          # :nocov:
          raise Support::Authorization::InvalidCondition, condition
          # :nocov:
        end
      end

      # @param [(:and, ConditionList), (:any, ConditionList), (:not, ConditionName), ConditionName] condition
      def resolve_condition?(condition)
        resolve_condition(condition).to_result.success?
      end

      private

      # @param [Dry::Monads::Validated] validated
      # @return [Dry::Monads::Validated]
      def negate_condition(validated)
        validated.to_result.flip.to_validated
      end

      # @param [Array] conditions (@see #resolve_condition)
      # @return [<Dry::Monads::Validated>]
      def map_conditions(conditions)
        # :nocov:
        raise ArgumentError, "must have at least one condition" if conditions.blank?
        # :nocov:

        conditions.map do |cond|
          resolve_condition cond
        end
      end

      # @param [Array] conditions (@see #resolve_condition)
      # @return [Dry::Monads::Validated]
      def resolve_all_conditions(conditions)
        traverse_conditions map_conditions conditions
      end

      # @param [Array] conditions (@see #resolve_condition)
      # @return [Dry::Monads::Validated]
      def resolve_any_conditions(conditions)
        valid, invalid = map_conditions(conditions).partition { _1.to_result.success? }

        traverse_conditions valid.presence || invalid
      end

      # @param [Array] conditions (@see #resolve_condition)
      # @return [Dry::Monads::Validated]
      def resolve_nor_conditions(conditions)
        negate_condition resolve_any_conditions(conditions)
      end

      # @param [Array] conditions (@see #resolve_condition)
      # @return [Dry::Monads::Validated]
      def resolve_not_conditions(conditions)
        negate_condition resolve_all_conditions(conditions)
      end

      # @return [Dry::Monads::Validated]
      def resolve_single_condition(condition_name)
        if has_condition?(condition_name)
          cond = self.class.condition_mapping.fetch(condition_name)

          cond.call(self)
        else
          raise Support::Authorization::InvalidCondition, condition_name
        end
      end

      # @param [<Dry::Monads::Validated>] validations
      # @return [Dry::Monads::Validated<Dry::Monads::List::Validated>]
      def traverse_conditions(validations)
        List::Validated.coerce(validations).traverse.fmap(FLATTEN_CONDITIONS).alt_map(FLATTEN_CONDITIONS)
      end

      module ClassMethods
        # @param [Symbol] name
        # @return [void]
        def define_condition!(name, meth = nil, **options, &resolver)
          if meth.present? && block_given?
            # :nocov:
            raise ArgumentError, "cannot provide both a method and a resolver for #{self} condition: #{name.inspect}"
            # :nocov:
          end

          condition = Support::Authorization::Condition.new(name, meth || resolver, **options)

          set_condition! name, condition
        end

        # @param [Class<Support::Authorization::DefinesConditions>] klass
        # @param [Symbol] source the name of the attribute that provides an instance of said klass
        # @return [void]
        def inherit_conditions_from!(klass, source)
          ConditionSource[klass].conditions.each do |name|
            delegated = Support::Authorization::DelegatedCondition.new(name:, klass:, source:)

            set_condition! name, delegated
          end
        end

        private

        # @param [Symbol] name
        # @param [Object] value
        # @return [void]
        def set_condition!(name, value)
          add_condition! name

          current_mapping = condition_mapping

          condition_mapping current_mapping.merge(name => value).freeze
        end
      end
    end
  end
end
