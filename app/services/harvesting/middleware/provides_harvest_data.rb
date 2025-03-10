# frozen_string_literal: true

module Harvesting
  module Middleware
    module ProvidesHarvestData
      extend ActiveSupport::Concern

      included do
        include Dry::Effects::Handler.Reader(:harvest_attempt)
        include Dry::Effects::Handler.Reader(:harvest_configuration)
        include Dry::Effects::Handler.Reader(:harvest_entity)
        include Dry::Effects::Handler.Reader(:harvest_mapping)
        include Dry::Effects::Handler.Reader(:harvest_record)
        include Dry::Effects::Handler.Reader(:harvest_source)
        include Dry::Effects::Handler.Reader(:metadata_format)
      end

      # @api private
      # @return [void]
      def provide_harvest_attempt!
        with_harvest_attempt harvest_attempt do
          yield
        end
      end

      # @api private
      # @return [void]
      def provide_harvest_configuration!
        with_harvest_configuration harvest_configuration do
          yield
        end
      end

      # @api private
      # @return [void]
      def provide_harvest_entity!
        with_harvest_entity harvest_entity do
          yield
        end
      end

      # @api private
      # @return [void]
      def provide_harvest_mapping!
        with_harvest_mapping harvest_mapping do
          yield
        end
      end

      # @api private
      # @return [void]
      def provide_harvest_record!
        with_harvest_record harvest_record do
          yield
        end
      end

      # @api private
      # @return [void]
      def provide_harvest_source!
        with_harvest_source harvest_source do
          yield
        end
      end

      # @api private
      # @return [void]
      def provide_metadata_format!
        with_metadata_format metadata_format do
          yield
        end
      end
    end
  end
end
