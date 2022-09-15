# frozen_string_literal: true

module Types
  class BaseObject < Types::AbstractObjectType
    edge_type_class Types::BaseEdge

    connection_type_class Types::BaseConnection

    field_class Types::BaseField

    def call_operation(name, *args, &block)
      WDPAPI::Container[name].call(*args, &block)
    end

    def call_operation!(name, *args)
      call_operation(name, *args).value!
    end

    # @api private
    # @param [Promise(HierarchicalEntity)] promise
    # @return [void]
    def track_entity_event!(promise, name: "entity.view", **data)
      promise.then do |entity|
        break if entity.blank? || context[:ahoy].blank?

        data[:entity] = entity

        context[:ahoy].track name, data
      end
    end

    # @api private
    # @param [String] name
    # @return [Analytics::EventCountSummary]
    def resolve_analytics_event_counts(name, **options)
      options[:name] = name

      ::Analytics::EventResolver.new(**options).call
    end

    # @api private
    # @param [String] name
    # @return [Analytics::RegionCountSummary]
    def resolve_analytics_region_counts(name, **options)
      options[:name] = name

      ::Analytics::EventRegionResolver.new(**options).call
    end

    class << self
      def use_direct_connection_and_edge!(
        base_name: graphql_name,
        connection_klass_name: "Types::#{base_name}ConnectionType",
        edge_klass_name: "Types::#{base_name}EdgeType"
      )
        @connection_type = connection_klass_name.constantize
        @edge_type = edge_klass_name.constantize
      end
    end
  end
end
