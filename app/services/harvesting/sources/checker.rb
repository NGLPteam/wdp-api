# frozen_string_literal: true

module Harvesting
  module Sources
    # @see Harvesting::Sources::Check
    class Checker < Support::HookBased::Actor
      include Harvesting::Middleware::ProvidesHarvestData
      include Dry::Effects::Handler.Interrupt(:check_failed, as: :catch_check_failed)
      include Dry::Initializer[undefined: false].define -> do
        param :harvest_source, Harvesting::Types::Source
      end

      standard_execution!

      # @return [Harvesting::Protocols::Context]
      attr_reader :context

      # @return [ActiveSupport::TimeWithZone]
      attr_reader :checked_at

      # @return [Harvesting::Types::SourceStatus]
      attr_reader :status

      around_execute :provide_harvest_source!

      # @return [Dry::Monads::Success(HarvestSource)]
      def call
        run_callbacks :execute do
          yield prepare!

          yield check!
        end

        harvest_source.update_columns(checked_at:, status:)

        Success harvest_source
      end

      wrapped_hook! def prepare
        @context = harvest_source.build_protocol_context

        @checked_at = Time.current

        @status = "inactive"

        super
      end

      wrapped_hook! def check
        context.perform_check!

        @status = "active"

        super
      end

      around_execute :with_check_failed!

      private

      # @return [void]
      def with_check_failed!
        failed, _ = catch_check_failed do
          yield
        end

        @status = "inactive" if failed
      end
    end
  end
end
