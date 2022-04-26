# frozen_string_literal: true

module Seeding
  module Export
    # @todo Handle assets when we need to support them.
    class SchemaPropertiesExporter < AbstractExporter
      param :broker, Seeding::Brokers::SchemaBroker::Type
      param :entity, Seeding::Types::Entity

      delegate :suppressed?, to: :broker

      def export!(json)
        entity.read_properties.value_or([]).each do |property|
          apply!(property, json)
        end
      end

      private

      # @param [Schemas::Properties::GroupReader, Schemas::Properties::Reader] property
      # @param [Jbuilder] json
      # @return [void]
      def apply!(property, json)
        return if suppressed? property.full_path

        return apply_group!(property, json) if property.group?

        value = value_for property

        json.set! property.path, value.as_json
      end

      # @param [Schemas::Properties::GroupReader] group
      # @param [Jbuilder] json
      # @return [void]
      def apply_group!(group, json)
        json.set! group.path do
          group.properties.each do |property|
            apply! property, json
          end
        end
      end

      # @param [Schemas::Properties::Reader] property
      # @return [#as_json]
      def value_for(property)
        case property.type
        when "entities"
          Array(property.value).map(&:identifier)
        when "entity"
          property.value&.identifier
        else
          property.value
        end
      end
    end
  end
end
