# frozen_string_literal: true

module Harvesting
  module Actions
    # @abstract
    class Runner
      extend Dry::Initializer
      extend Dry::Core::ClassAttributes

      include Shared::Typing

      Logger = Harvesting::Types.Instance(HasHarvestErrors).optional

      defines :error_logger, type: Harvesting::Types::Symbol.optional

      delegate :clear_harvest_errors!, :log_harvest_error!, allow_nil: true, to: :harvest_error_target

      # @api private
      # @return [HasHarvestErrors, nil]
      def harvest_error_target
        attribute = self.class.error_logger

        return unless attribute

        model = public_send attribute

        Logger[model]
      end

      class << self
        def logs_errors?
          self < Harvesting::Actions::Runner::LogsErrors
        end

        # @param [Symbol] attribute
        # @return [void]
        def logs_errors_from!(attribute)
          include Harvesting::Actions::Runner::LogsErrors

          error_logger attribute
        end

        # @return [Symbol]
        def first_argument
          dry_initializer.definitions.values.first.target
        end
      end

      # @api private
      module LogsErrors
        extend ActiveSupport::Concern
      end
    end
  end
end
