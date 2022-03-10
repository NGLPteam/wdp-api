# frozen_string_literal: true

module Harvesting
  # @abstract
  class BaseAction
    extend ActiveModel::Callbacks
    extend Dry::Core::ClassAttributes

    include Dry::Monads[:result, :do]
    include Harvesting::HushActiveRecord
    include WDPAPI::Deps[
      wrap_middleware: "harvesting.middleware.wrap",
    ]

    define_model_callbacks :perform

    defines :runner_klass, type: Harvesting::Actions::Runner::Subclass

    runner_klass Harvesting::Actions::Runner

    delegate :runner_klass, to: :class

    defines :extract_middleware_from, type: Harvesting::Types::Symbol.optional

    extract_middleware_from nil

    delegate :extract_middleware_from, to: :class

    defines :first_argument_provides_middleware, type: Harvesting::Types::Bool

    first_argument_provides_middleware false

    delegate :first_argument_provides_middleware, to: :class

    defines :hush_active_record, type: Harvesting::Types::Bool

    hush_active_record true

    delegate :hush_active_record, to: :class

    defines :deferred_ordering_refresh, type: Harvesting::Types::Bool

    deferred_ordering_refresh false

    delegate :deferred_ordering_refresh, to: :class

    around_perform :with_hushed_active_record, if: :hush_active_record
    around_perform :provide_middleware!, if: :can_provide_middleware?
    around_perform :with_deferred_ordering_refresh, if: :deferred_ordering_refresh

    # @return [Harvesting::Actions::Runner]
    attr_reader :runner

    # @return [Dry::Monads::Result]
    def call(*args, **options)
      @args = args
      @options = options

      @runner = runner_klass.new(*args, **options)

      run_callbacks :perform do
        perform(*args, **options)
      end
    ensure
      @runner = nil
      @args = []
      @options = {}
    end

    # @abstract
    # @api private
    # @return [Dry::Monads::Result]
    def perform(*)
      # :nocov:
      Success()
      # :nocov:
    end

    # @api private
    def can_provide_middleware?
      extract_middleware_from.present? || first_argument_provides_middleware
    end

    # @api private
    # @return [void]
    def provide_middleware!
      provider = middleware_provider

      wrap_middleware.(provider) do
        yield
      end
    end

    # @api private
    # @return [void]
    def with_deferred_ordering_refresh
      Schemas::Orderings.with_deferred_refresh do
        yield
      end
    end

    # @api private
    # @return [void]
    def with_hushed_active_record
      silence_activerecord do
        yield
      end
    end

    private

    def middleware_provider
      if extract_middleware_from
        @runner.public_send extract_middleware_from
      elsif first_argument_provides_middleware
        @runner.public_send runner_klass.first_argument
      end
    end

    class << self
      # Declare that this action should defer ordering refreshing until it is complete.
      #
      # @return [void]
      def defer_ordering_refresh!
        deferred_ordering_refresh true
      end

      # Declare that the first argument this action should wrap its performance
      # in middleware.
      #
      # @see Harvesting::Middleware::Wrap
      # @return [void]
      def first_argument_provides_middleware!
        first_argument_provides_middleware true
      end

      # @return [void]
      def runner(&block)
        klass = Class.new(runner_klass)

        klass.class_eval(&block)

        runner_klass klass

        const_set :Runner, klass

        delegate :clear_harvest_errors!, :log_harvest_error!, to: :runner, allow_nil: true if klass.logs_errors?
      end
    end
  end
end
