# frozen_string_literal: true

module MutationOperations
  module Base
    extend ActiveSupport::Concern

    include Graphql::PunditHelpers
    include MutationOperations::AttributeExtraction
    include MutationOperations::Contracts

    included do
      extend ActiveModel::Callbacks

      include Dry::Effects.CurrentTime
      include Dry::Effects.Resolve(:current_user)
      include Dry::Effects.Resolve(:graphql_context)
      include Dry::Effects.Resolve(:local_context)
      include Dry::Effects.Resolve(:attribute_names)
      include Dry::Effects.Resolve(:error_compiler)
      include Dry::Effects.Resolve(:transient_arguments)
      include Dry::Effects.State(:graphql_response)
      include Dry::Effects.Interrupt(:throw_invalid)
      include Dry::Effects.Interrupt(:throw_unauthorized)
      include Dry::Monads[:result, :validated, :list]

      define_model_callbacks :prepare, :contracts, :validation, :execution
    end

    # @api private
    # @return [void]
    def perform!(**args)
      local_context[:args] = args

      local_context[:execution_args] = args.dup

      run_callbacks :prepare do
        prepare!(**args)
      end

      run_callbacks :validation do
        run_callbacks :contracts do
          check_contracts!(**args)
        end

        validate!(**args)
      end

      halt_if_errors!

      unset_transient_arguments!

      run_callbacks :execution do
        exec_args = local_context.fetch(:execution_args).deep_symbolize_keys

        call(**exec_args)
      end
    end

    def attach!(key, value)
      if graphql_response.key?(key) && value != graphql_response[key]
        warn "already assigned value to graphql_response[#{key.inspect}]: #{graphql_response[key]}"
      end

      graphql_response[key] = value
    end

    # @param [String] message
    # @param [String] code
    # @param [String, String[]] path
    # @param [Hash] extensions
    # @return [void]
    def add_error!(message, code: nil, path: nil, force_attribute: false)
      error = error_compiler.call(message, code: code, path: path, force_attribute: force_attribute)

      graphql_response[:errors] << error

      if error.global?
        graphql_response[:global_errors] << error.to_global_error
      else
        graphql_response[:attribute_errors].then do |errors|
          key = error.attribute_error_key

          errors[key] ||= []

          errors[key] << error.message
        end
      end
    end

    # @param [String] message
    # @return [void]
    def add_global_error!(message, type: "$global")
      error = error_compiler.global message

      graphql_response[:errors] << error

      graphql_response[:global_errors] << error.to_global_error
    end

    # @return [void]
    def halt_if_errors!
      throw_invalid if has_errors?
    end

    def has_errors?
      graphql_response[:errors].any? || graphql_response[:global_errors].any? || graphql_response[:attribute_errors].any?
    end

    # @abstract
    # @return [void]
    def prepare!(**args); end

    # @abstract
    # @return [void]
    def validate!(**args); end

    # @return [void]
    def unset_transient_arguments!
      return if transient_arguments.none?

      unset_arg_for_execution!(*transient_arguments)
    end

    # @!group Authorization logic

    def authorize(*)
      super
    rescue Pundit::NotAuthorizedError => e
      throw_unauthorized e
    end

    def pundit_user
      current_user
    end

    # @!endgroup

    # @!group model persistence

    def persist_model!(model, attach_to: nil)
      if model.save
        attach! attach_to, model if attach_to.present?

        return model
      else
        invalid_model! model
      end
    end

    def upsert_model!(klass, attributes, unique_by:, attach_to: nil)
      result = klass.upsert attributes, returning: unique_by, unique_by: unique_by

      conditions = unique_by.each_with_object({}) do |key, h|
        h[key.to_sym] = result.first[key.to_s]
      end

      model = klass.find_by! conditions

      attach! attach_to, model if attach_to.present?

      return model
    end

    def validate_model!(model, validation_context: nil)
      if model.valid? validation_context
        model
      else
        invalid_model! model
      end
    end

    def check_model!(model)
      return model if model.errors.none?

      invalid_model! model
    end

    def invalid_model!(model)
      add_model_errors! model

      throw_invalid
    end

    def destroy_model!(model, auth: false)
      graphql_response[:destroyed] = false

      authorize model, :destroy? if auth

      id = model.to_encoded_id

      if model.destroy
        graphql_response[:destroyed] = true

        graphql_response[:destroyed_id] = id
      else
        invalid_model! model
      end
    end

    # @param [#errors] model
    # @return [void]
    def add_model_errors!(model)
      model.errors.each do |error|
        options = {}.tap do |h|
          h[:code] = error.type.to_s if error.type.kind_of?(Symbol)
          h[:path] = [error.attribute] unless error.attribute == :base
        end

        add_error! error.message, **options
      end
    end

    # @!endgroup

    # @!group Utility methods

    # @param [String] name the fully-qualified name of the operation
    # @param [<Object>] args the arguments for the operation (if any)
    # @return [Dry::Monads::Result] This is not guaranteed, but assumed for most operations
    #   that would be called by a mutation
    def call_operation(name, *args)
      WDPAPI::Container[name].call(*args)
    end

    # @param [<Symbol>] keys
    # @return [void]
    def unset_arg_for_execution!(*keys)
      keys.flatten.each do |key|
        local_context[:execution_args].delete key
      end
    end

    # Call an operation by name and run through {#with_result!} in order
    # to easily handle its result.
    #
    # @note This differs from {#with_operation_result!} in that we inline the operation
    #   call and also allow the implementation to use its own resolution logic.
    # @param [String] name the fully-qualified name of the operation
    # @param [<Object>] args the arguments for the operation (if any)
    # @yield [matcher] handle the result of the operation based on `success` or `failure`
    # @yieldparam [Dry::Matcher::ResultMatcher] matcher
    # @yieldreturn [void]
    # @return [void]
    def with_called_operation!(name, *args, &block)
      result = call_operation(name, *args)

      with_result! result, &block
    end

    def with_result!(result, &block)
      Dry::Matcher::ResultMatcher.call(result, &block)
    end

    def with_operation_result!(result)
      with_result!(result) do |m|
        m.success do |value|
          value
        end

        m.failure do |failure|
          if failure.kind_of?(Array) && failure.length == 2
            add_global_error! failure[1], type: failure[0].to_s
          else
            add_global_error! "Something went wrong"
          end
        end
      end
    end

    def with_attached_result!(key, result)
      with_result! result do |m|
        m.success do |model|
          attach! key, model
        end

        m.failure do |(code, reason)|
          if reason.kind_of?(ApplicationRecord)
            invalid_model! reason

            break
          end

          message = reason.kind_of?(String) ? reason : "Something went wrong"

          add_error! message, code: code.to_s.presence
        end
      end
    end

    # @!endgroup

    # @!group Schema Errors

    # @!endgroup
  end
end
