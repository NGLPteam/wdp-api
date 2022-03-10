# frozen_string_literal: true

module Schemas
  # Dynamic, automatically-maintained orderings of entities for specific schema versions.
  module Orderings
    class << self
      # Set options for refreshing orderings as a part of model lifecycles.
      #
      # @see Schemas::Orderings::RefreshStatus
      def refresh(**options)
        Schemas::Orderings::RefreshStatus.new(**options).wrap do
          yield if block_given?
        end
      end

      # @see .refresh
      # @param [<HierarchicalEntity, SchemaVersion, String>] entities
      # @param [{ Symbol => Object }] options
      # @return [void]
      def skip_refresh_for(*things, **options, &block)
        things.flatten!

        options[:skip_entities] ||= []
        options[:skip_identifiers] ||= []
        options[:skip_schemas] ||= []

        things.each do |thing|
          case thing
          when ::HierarchicalEntity
            options[:skip_entities] << thing
          when ::String
            options[:skip_identifiers] << thing
          when ::SchemaVersion
            options[:skip_schemas] << thing
          else
            # :nocov:
            raise ArgumentError, "Don't know how to skip #{thing.inspect}"
            # :nocov:
          end
        end

        refresh(options, &block)
      end

      # @see .refresh
      # @param [{ Symbol => Object }] options
      # @return [void]
      def with_asynchronous_refresh(**options, &block)
        options[:async] = true

        refresh(options, &block)
      end

      # @see https://dry-rb.org/gems/dry-effects/master/effects/defer/
      # @see .refresh
      # @param [{ Symbol => Object }] options
      # @return [void]
      def with_deferred_refresh(**options, &block)
        options[:deferred] = true
        options[:async] = true

        refresh(options, &block)
      end

      # @see .refresh
      # @param [{ Symbol => Object }] options
      # @return [void]
      def with_disabled_refresh(**options, &block)
        options[:disabled] = true

        refresh(options, &block)
      end
    end
  end
end
