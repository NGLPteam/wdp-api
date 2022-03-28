# frozen_string_literal: true

module Testing
  module Merced
    # @operation
    class UpsertUnit
      include Dry::Monads[:do, :result]
      include Dry::Effects.Resolve(:community)
      include Dry::Effects.Resolve(:parent_counts)
      include Dry::Effects.State(:unit_ids)
      include MonadicPersistence
      prepend HushActiveRecord

      SCHEMA_PROPERTY_PATHS = %w[
        about
      ].freeze

      # @param [ActiveSupport::HashWithIndifferentAccess] unit_definition
      # @return [Dry::Monads::Success(Collection)]
      def call(unit_definition, parent: nil)
        unit_id = unit_definition[:id]

        return Success(community) if unit_id == "ucm"

        collection = parent_scope(parent).by_identifier(unit_id).first_or_initialize

        collection.schema_version = yield version_for unit_definition[:type]

        inject_core_attributes_into! collection, unit_definition

        yield monadic_save collection

        yield extract_and_apply_schema_properties! collection, unit_definition

        unit_ids << unit_id

        parent_counts[unit_id] += 1

        Success collection
      end

      private

      # @param [Collection] collection
      # @param [ActiveSupport::HashWithIndifferentAccess] unit_definition
      # @return [void]
      def inject_core_attributes_into!(collection, unit_definition)
        # collection.hero_image_attacher.assign_remote_url unit_definition.dig(:hero, :asset_url)
        # collection.thumbnail_attacher.assign_remote_url unit_definition.dig(:logo, :asset_url)
        collection.title = unit_definition[:name]
      end

      def extract_and_apply_schema_properties!(collection, unit_definition)
        props = {}

        SCHEMA_PROPERTY_PATHS.each_with_object(props) do |path, p|
          p[path] = unit_definition[path] if unit_definition.key?(path)
        end

        properties = props.compact

        collection.apply_properties! properties
      end

      def parent_scope(parent)
        if parent.present? && parent.kind_of?(Collection)
          parent.children
        else
          community.collections
        end
      end

      def version_for(type)
        case type
        when "oru"
          Success SchemaVersion["nglp:unit"]
        when "series"
          Success SchemaVersion["nglp:series"]
        else
          Failure[:unknown_type, "Cannot get schema for nglp type: #{type}"]
        end
      end
    end
  end
end
