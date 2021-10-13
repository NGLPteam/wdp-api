# frozen_string_literal: true

module Harvesting
  module Entities
    class Upsert
      include Dry::Monads[:do, :result]
      include Dry::Effects.Resolve(:collection)
      include Dry::Effects.Resolve(:harvest_attempt)
      include Dry::Effects.Resolve(:harvest_record)
      include Dry::Effects.Resolve(:harvest_source)
      include Dry::Effects.Resolve(:metadata_processor)
      include MonadicPersistence

      # @param [HarvestEntity] entity
      # @return [Collection, Item]
      def call(harvest_entity)
        entity = yield attach! harvest_entity, parent: collection

        Success entity
      end

      private

      def attach!(harvest_entity, parent:)
        scope = yield scope_for parent, harvest_entity

        entity = scope.by_identifier(harvest_entity.identifier).first_or_initialize

        entity.schema_version = harvest_entity.schema_version

        entity.assign_attributes harvest_entity.extracted_attributes

        # TODO: schema properties, assets

        yield monadic_save entity

        harvest_entity.children.find_each do |child|
          yield attach! child, parent: entity
        end

        Success entity
      end

      def scope_for(parent, harvest_entity)
        parent_type = yield type_for parent
        child_type = yield type_for harvest_entity

        case [parent_type, child_type]
        when [:collection, :item]
          Success parent.items
        when [:collection, :collection], [:item, :item]
          Success parent.children
        else
          Failure[:invalid_parentage, "cannot create child of type #{child_type} under #{parent_type}"]
        end
      end

      # @param [ActiveRecord::Base] model
      # @return [:collection, :item]
      def type_for(model)
        case model
        when ::Collection
          Success :collection
        when ::Item
          Success :item
        when ::SchemaVersion
          type_from_version model
        when ::HarvestEntity
          type_from_harvest_entity harvest_entity
        else
          # :nocov:
          Failure[:unknown_type, "Cannot derive entity type from #{model.inspect}"]
          # :nocov:
        end
      end

      # @param [SchemaVersion] schema_version
      # @return [:collection, :item]
      def type_from_version(schema_version)
        if schema_version.item?
          Success :item
        elsif schema_version.collection?
          Success :collection
        else
          # :nocov:
          Failure[:invalid_schema_version, "expected an item or collection schema"]
          # :nocov:
        end
      end

      # @param [HarvestEntity] harvest_entity
      # @return [:collection, :item]
      def type_from_harvest_entity(harvest_entity)
        if harvest_entity.schema_version.present?
          type_from_version harvest_entity.schema_version
        else
          Success :item
        end
      end
    end
  end
end
