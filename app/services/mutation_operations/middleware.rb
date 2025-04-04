# frozen_string_literal: true

module MutationOperations
  class Middleware
    extend Dry::Initializer

    include Dry::Effects::Handler.CurrentTime
    include Dry::Effects::Handler.Resolve
    include Dry::Effects::Handler.State(:graphql_response)
    include Dry::Effects::Handler.Interrupt(:throw_invalid, as: :catch_invalid)
    include Dry::Effects::Handler.Interrupt(:throw_unauthorized, as: :catch_unauthorized)
    include Dry::Monads[:result]

    TO_RESULT = MonadHelpers::ToResult.new

    option :context, ::Support::GlobalTypes.Interface(:[])
    option :now, ::Support::GlobalTypes.Interface(:call), default: proc { proc { Time.current } }
    option :mutation, Support::GlobalTypes.Instance(Mutations::BaseMutation).optional, optional: true
    option :operation_name, Support::GlobalTypes::String.optional
    option :attribute_names, Support::GlobalTypes::Array.of(Support::GlobalTypes::String)
    option :transient_arguments, Support::GlobalTypes::Array.of(Support::GlobalTypes::Symbol)
    option :error_compiler, Support::GlobalTypes.Instance(MutationOperations::ErrorCompiler),
      default: proc {
        MutationOperations::ErrorCompiler.new attribute_names:
      }

    # @param [#call] operation
    # @param [Array] args
    def call(operation, **args)
      response, result = with_graphql_response(base_response) do
        Mutations.with_active! do
          with_transaction do
            with_effects_stack(args:) do
              operation.perform!
            end
          end
        end
      end

      Dry::Matcher::ResultMatcher.(result) do |m|
        m.success do
          response
        end

        m.failure(:throw_unauthorized) do
          GraphQL::ExecutionError.new(I18n.t("server_messages.auth.forbidden"),
            extensions: {
              code: "FORBIDDEN"
            }
          )
        end

        m.failure(:throw_invalid) do
          response[:halt_code] = "invalid"

          strip_response_for_invalid(response)
        end

        m.failure do |*reason|
          # TODO: Rollbar this.

          GraphQL::ExecutionError.new I18n.t("server_messages.errors.something_went_wrong"), extensions: { code: "INTERNAL_SERVER_ERROR" }
        end
      end
    end

    private

    def base_response
      { errors: [], global_errors: [], attribute_errors: {} }.with_indifferent_access
    end

    def base_local_context
      {}.with_indifferent_access
    end

    def strip_response_for_invalid(response)
      response.slice(:halt_code, :errors, :schema_errors, :global_errors, :attribute_errors)
    end

    def current_user
      context[:current_user].presence || AnonymousUser.new
    end

    def dependency_injections(args: {})
      {
        attribute_names:,
        current_user:,
        error_compiler:,
        graphql_context: context,
        local_context: base_local_context,
        provided_args: args.freeze,
        transient_arguments:,
      }
    end

    def with_effects_stack(args: {})
      with_current_time(now) do
        provide(dependency_injections(args:)) do
          yield
        end
      end
    end

    def with_interrupt_handlers
      result = catch(:halt_everything) do
        stack_interrupt_handlers(throw_invalid: :catch_invalid, throw_unauthorized: :catch_unauthorized) do
          wrap_actual_execution do
            yield
          end
        end
      end

      return result.success?, result
    end

    def wrap_actual_execution
      raw_result = yield

      result = TO_RESULT.call raw_result

      if result.success?
        return false, result
      else
        throw :halt_everything, result
      end
    end

    def stack_interrupt_handlers(**mappings, &initial_block)
      stack = mappings.to_a.reverse.reduce initial_block do |child, (name, wrapper_name)|
        -> do
          error, result = __send__(wrapper_name) do
            child.call
          end

          unless error
            TO_RESULT.call(result)
          else
            throw :halt_everything, Failure[name, result]
          end
        end
      end

      stack.call
    end

    def with_transaction
      tx_context = { rolled_back: false }

      result = ApplicationRecord.transaction do
        success, raw_result = with_interrupt_handlers do
          yield
        end

        result = TO_RESULT.call raw_result

        tx_context[:success] = success
        tx_context[:result] = result

        if success
          result
        else
          tx_context[:rolled_back] = true

          raise ActiveRecord::Rollback
        end
      end

      tx_context[:result]
    end
  end
end
