# frozen_string_literal: true

module Mutations
  # @abstract
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    include Graphql::PunditHelpers

    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject

    def app_container
      WDPAPI::Container
    end

    def resolve_container_value(*args)
      app_container.resolve(*args)
    end

    def perform_operation(name, **args)
      middleware = MutationOperations::Middleware.new mutation: self, context: context, operation_name: name

      operation = resolve_container_value name

      middleware.call operation, **args
    end

    def perform_simple_operation(name, *args, &block)
      operation = resolve_container_value name

      result = operation.call(*args)

      Dry::Matcher::ResultMatcher.call(result, &block)
    end

    # @param [ApplicationRecord] instance
    # @param [Symbol] on
    # @return [{ Symbol => Object }]
    def provide_model(instance, on: instance.model_name.i18n_key)
      if instance.errors.none?
        {
          on => instance,
          errors: []
        }
      else
        errors = instance.errors.map do |error|
          {}.tap do |h|
            h[:message] = error.message
            h[:code] = error.type.to_s if error.type.kind_of?(Symbol)
            h[:path] = [error.attribute] unless error.attribute == :base
          end
        end

        { errors: errors }
      end
    end

    class << self
      # @return [void]
      def has_user_errors!
        field :errors, [Types::UserError], null: false

        field :halt_code, String, null: true
      end

      # @param [String] name
      # @return [void]
      def performs_operation!(name, has_errors: true)
        has_user_errors! if has_errors

        class_eval <<~RUBY, __FILE__, __LINE__ + 1
        def resolve(**args)
          perform_operation(#{name.inspect}, **args)
        end
        RUBY
      end
    end
  end
end
