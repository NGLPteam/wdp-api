# frozen_string_literal: true

module Support
  module HookBased
    # @abstract
    class Actor
      extend ActiveModel::Callbacks
      extend Dry::Core::ClassAttributes
      extend Support::DoFor

      include Dry::Effects::Handler.Interrupt(:halt_actor, as: :catch_actor_halt)
      include Dry::Effects.Interrupt(:halt_actor)

      include Dry::Monads[:result, :try]

      # @api private
      TO_RESULT = Support::MonadHelpers::ToResult.new

      private_constant :TO_RESULT

      defines :benchmark_hooks, type: Types::Bool

      benchmark_hooks false

      defines :generic_process_error_key, type: Types::Symbol

      generic_process_error_key :process_error

      defines :halt_error_klass, type: Types::Class

      halt_error_klass Support::HookBased::Halted

      # @return [Symbol]
      attr_reader :current_hook

      # @api private
      def inspect
        # :nocov:
        "#<#{self.class}>"
        # :nocov:
      end

      # @param [Dry::Monads::Result] result
      # @return [Dry::Monads::Result]
      def process(result)
        Dry::Matcher::ResultMatcher.(result) do |m|
          m.success do
            on_success
          end

          m.failure :actor_halt do |_, reason|
            on_halt(reason)
          end

          m.failure do |*args|
            on_failure(*args)
          end
        end
      end

      # @abstract
      # @api private
      # @return [Dry::Monads::Result]
      def on_success
        Success()
      end

      # @param [Symbol] reason
      # @raise [Support::HookBased::Halted]
      # @return [void]
      def on_halt(reason)
        raise self.class.halt_error_klass, reason
      end

      # @abstract
      # @api private
      # @return [Dry::Monads::Result]
      def on_failure(*args)
        # :nocov:
        case args
        in Exception => err, *_
          raise err
        in Symbol => code, *rest
          Failure[code, *rest]
        else
          Failure[self.class.generic_process_error_key, *args]
        end
        # :nocov:
      end

      # @api private
      # @yieldreturn [Dry::Monads::Result]
      # @return [Dry::Monads::Result]
      def enforce_monadic
        halted, response = catch_actor_halt do
          retval = yield

          TO_RESULT.call(retval)
        end

        if halted
          Failure[:actor_halt, response]
        else
          response
        end
      end

      def benchmark_hook!
        # :nocov:
        time = AbsoluteTime.realtime do
          yield
        end

        warn "hook #{current_hook} took #{time}s"
        # :nocov:
      end

      def benchmark_hooks?
        self.class.benchmark_hooks && Rails.env.development?
      end

      class << self
        # @return [void]
        def benchmark_hooks!
          benchmark_hooks true
        end

        # @param [Symbol] attr
        # @return [void]
        def simple_reader!(attribute, **options)
          mod = SimpleReader.new(attribute, **options)

          include mod
        end

        def stateful_counter!(attribute, **options)
          mod = StatefulCounter.new(attribute, **options)

          include mod
        end

        def standard_execution!
          do_for! :call

          define_model_callbacks :execute
        end

        def wrapped_hook!(name)
          mod = WrappedHook.new(name)

          include mod
        end
      end
    end
  end
end
