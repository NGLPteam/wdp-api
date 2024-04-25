# frozen_string_literal: true

module Support
  module Authorization
    # Define actions (with matching predicates) for use in policy classes.
    #
    # Subpolicies can override without affecting their parents.
    module DefinesActions
      extend ActiveSupport::Concern

      include DefinesConditions

      ActionResolution = Support::Authorization::Action::Type | Support::Authorization::DelegatedAction

      ActionMapping = Types::Hash.map(Types::ActionName, ActionResolution)

      included do
        extend Dry::Core::ClassAttributes

        extend Support::TypedSet.of(Types::ActionName)[:actions]

        extend Support::TypedSet.of(Types::Predicate)[:predicates]

        defines :action_mapping, type: ActionMapping

        action_mapping({}.freeze)
      end

      # @param [Symbol] name
      # @return [Dry::Monads::Validated]
      def resolve_action(name)
        action = action_mapping.fetch name

        action.call(self)
      end

      # @param [Symbol] name
      def resolve_action?(name)
        resolve_action(name).to_result.success?
      end

      private

      # @return [{ Symbol => Support::Authorization::Action, Support::Authorization:DelegatedAction }]
      def action_mapping
        self.class.action_mapping
      end

      module ClassMethods
        # @see Support::Authorization::DelegatedAction
        def delegate_action!(from, to:)
          set_action! from, Support::Authorization::DelegatedAction.new(from:, to:)
        end

        # @param [<Symbol>] names
        # @param [Symbol] to
        def delegate_actions!(*names, to:)
          Types::ActionNames[names].each do |from|
            delegate_action! from, to:
          end
        end

        # @param [Array] conditions
        # @param [<Symbol>] aliases
        # @param [Symbol, <Symbol>] on
        # @param [:all, :any, :nor, :not] logic
        # @return [void]
        def require_condition!(*conditions, on:, logic: :all, aliases: [])
          case on
          in Types::ActionName => to
            set_action_resolution!(to, conditions, logic:)

            delegate_actions!(*aliases, to:) if aliases.any?
          in Types::ActionNames => action_names
            # :nocov:
            raise ArgumentError, "cannot specify `aliases` when `on` is an array" if aliases.any?
            # :nocov:

            action_names.each do |condition_name|
              set_action_resolution!(condition_name, conditions, logic:)
            end
          end
        end

        # Wrap the list of incoming conditions as needing at least one to be satisfied.
        def require_any_condition!(*conditions, **args)
          args[:logic] = :any

          require_condition!(*conditions, **args)
        end

        private

        # @param [Symbol] name
        # @return [void]
        def define_action_predicate_for!(name)
          actions actions.add(name)

          predicate = :"#{name}?"

          predicates predicates.add(predicate)

          return if method_defined? predicate

          class_eval <<~RUBY, __FILE__, __LINE__ + 1
          def #{predicate}                      # def read?
            resolve_action?(#{name.inspect}) #   resolve_action?(:read)
          end                                   # end
          RUBY
        end

        # @param [Symbol] name
        # @param [Action, DelegatedAction] action
        # @return [void]
        def set_action!(name, action)
          define_action_predicate_for! name

          current_mapping = action_mapping

          action_mapping current_mapping.merge(name => action).freeze
        end

        # @param [Symbol] name
        # @param [Array] conditions
        # @param [:all, :any, :nor, :not] logic
        # @return [void]
        def set_action_resolution!(name, conditions, logic: :all)
          action = Support::Authorization::Action.new(name, conditions, logic:)

          set_action! name, action
        end
      end
    end
  end
end
