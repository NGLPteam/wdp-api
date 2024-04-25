# frozen_string_literal: true

module Harvesting
  module Middleware
    # @abstract
    # @see Harvesting::Dispatch::BuildMiddlewareState
    class BaseBuilder
      include Dry::Monads[:do, :result]
      include MeruAPI::Deps[
        build_logger: "harvesting.dispatch.build_logger",
        build_metadata_format: "harvesting.dispatch.build_metadata_format",
        build_protocol: "harvesting.dispatch.build_protocol",
      ]

      # @param [ApplicationRecord] model
      # @return [Dry::Monads::Success({ Symbol => Object })]
      # @return [Dry::Monads::Failure]
      def call(model)
        @state = yield initial_state_from(model)

        parent = parent_for model

        yield inherit_middleware_from! parent if parent.present?

        yield build_from model

        Success(@state.symbolize_keys)
      ensure
        @state = nil
      end

      # @api private
      # @abstract
      # @param [ApplicationRecord] model
      # @return [Dry::Monads::Result]
      def build_from(model)
        # :nocov:
        Success(nil)
        # :nocov:
      end

      # @api private
      # @abstract
      # @param [ApplicationRecord] model
      # @return [ApplicationRecord, nil]
      def parent_for(model); end

      # @api private
      # @note We have to set this manually to avoid a stack lover
      # @see Harvesting::Dispatch::BuildMiddlewareState
      # @return [#call]
      def build_middleware_state
        MeruAPI::Container["harvesting.dispatch.build_middleware_state"]
      end

      # @api private
      # @param [ApplicationRecord] model
      def inherit_middleware_from!(model)
        result = yield build_middleware_state.call(model)

        merge!(**result)
      end

      # @api private
      def merge!(schemas: {}, **result)
        result.delete :logger if @state[:logger].present?

        @state.merge! result

        @state[:schemas].reverse_merge!(schemas)

        Success nil
      end

      # @api private
      # @param [Symbol] key
      # @param [Object] value
      # @return [void]
      def set!(key, value)
        @state[key] = value

        Success nil
      end

      # @api private
      # @param [ApplicationRecord] model
      # @return [void]
      def set_model!(model)
        key = model_key_for model

        set! key, model
      end

      def set_schema!(name, version_string)
        @state[:schemas][name] = SchemaVersion[version_string]

        Success nil
      end

      # @api private
      def set_protocol!(model, augment: true)
        @state[:protocol] = yield build_protocol.call(model)

        yield augment_middleware_with!(@state[:protocol]) if augment

        Success nil
      end

      # @api private
      def set_metadata_format!(model, augment: true)
        format = yield build_metadata_format.call(model)

        @state[:metadata_format] = format

        yield augment_middleware_with!(format) if augment

        Success nil
      end

      # @api private
      # @param [#augment_middleware] augmentor
      # @return [Dry::Monads::Success(void)]
      def augment_middleware_with!(augmentor)
        # :nocov:
        return Success(nil) if augmentor.blank?
        return Failure[:invalid_augmentor, "cannot augment middleware with #{augmentor.inspect}"] unless augmentor.respond_to?(:augment_middleware)

        # :nocov:

        yield augmentor.augment_middleware.call(@state)

        Success nil
      end

      private

      # @return [{ Symbol => Object }]
      def initial_state_from(model)
        state = {}.tap do |h|
          model_key = model_key_for model

          h[model_key] = model
          h[:logger] = yield build_logger.call model
          h[:schemas] = {}
        end

        Success state
      end

      # @param [#model_name, ApplicationRecord] model
      # @return [Symbol]
      def model_key_for(model)
        model.model_name.singular.to_sym
      end
    end
  end
end
