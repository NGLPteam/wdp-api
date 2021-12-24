# frozen_string_literal: true

module Schemas
  module Instances
    # Accept a {HasSchemaDefinition schema instance} and extract any given orderable properties from it.
    #
    # Namely, {EntityOrderableProperty} and {NamedVariableDate}.
    class ExtractOrderableProperties
      include Dry::Monads[:do, :result]
      include WDPAPI::Deps[
        instance_for: "schemas.utility.instance_for",
        read_orderable_values: "schemas.instances.read_orderable_property_values",
      ]

      # @param [HasSchemaDefinition, Entity, EntityLink] schema_instance (@see Schemas::Utility::InstanceFor for acceptable values to pass)
      # @param [Schemas::Properties::Context, nil] context
      # @return [Hash]
      def call(entity, context: nil)
        schema_instance = instance_for.call entity

        schema_version = schema_instance.schema_version

        values = yield read_orderable_values.call schema_instance, context: context

        entity_attrs = schema_instance.to_entity_pair

        vpdate_properties, other_properties = schema_version.schema_version_properties.orderable.partition do |svp|
          svp.with_variable_date_type?
        end

        vpdate_attributes = vpdate_properties.map do |svp|
          attrs = svp.to_named_variable_date_attributes

          entity_attrs.merge attrs.merge(actual: values[svp.path])
        end

        dates = yield upsert_named_variable_dates! vpdate_attributes

        orderable_attributes = other_properties.map do |svp|
          attrs = svp.to_entity_property_attributes

          entity_attrs.merge attrs.merge(raw_value: values[svp.path])
        end

        orderable_attributes += vpdate_attributes.map do |attr|
          attr.merge(type: "variable_date").tap do |h|
            h["raw_value"] = h.delete(:actual)
          end
        end

        props = yield upsert_orderable_properties! orderable_attributes

        result = { dates: dates, props: props }

        Success result
      end

      private

      def upsert_named_variable_dates!(attributes)
        return Success(0) if attributes.blank?

        res = NamedVariableDate.upsert_all(
          attributes,
          unique_by: %i[entity_type entity_id path]
        )

        Success res.length
      end

      def upsert_orderable_properties!(attributes)
        return Success(0) if attributes.blank?

        res = EntityOrderableProperty.upsert_all(
          attributes,
          unique_by: %i[entity_type entity_id path]
        )

        Success res.length
      end
    end
  end
end
