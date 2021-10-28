# frozen_string_literal: true

module Harvesting
  module Entities
    # This operation transforms a (root) {HarvestEntity} and all its descendants
    # into a set of {Collection collections} or {Item items}, based on the assigned
    # {SchemaVersion schema}. If the associated {HarvestEntity} has not set a schema,
    # it will fall back to an `default:item`.
    class Upsert
      include Dry::Monads[:do, :result]
      include Dry::Effects.Resolve(:collection)
      include Dry::Effects.Resolve(:schemas)
      include MonadicPersistence
      include WDPAPI::Deps[
        apply_properties: "schemas.instances.apply",
        attach_assets: "harvesting.entities.attach_assets",
        attach_contribution: "harvesting.contributions.attach",
      ]

      # @note The provided harvest entity must be `root` or else it would cause incongruent
      #   upsertions: something intended at the second level relative to the initial `Collection`
      #   would be right under it instead.
      # @param [HarvestEntity] entity
      # @return [Collection, Item] the root HarvestEntity's associated entity
      def call(harvest_entity)
        return Failure[:must_be_root, "The provided entity to upsert must be a root"] unless harvest_entity.root?

        entity = yield attach! harvest_entity, parent: collection

        Success entity
      end

      private

      def attach!(harvest_entity, parent:)
        entity = yield find_or_initialize_entity_for parent, harvest_entity

        yield apply_attributes! harvest_entity, entity

        yield assign_schema_version! harvest_entity, entity

        asset_properties = yield apply_assets! harvest_entity, entity

        yield apply_schema_version_and_properties!(harvest_entity, entity, assets: asset_properties)

        yield finalize! harvest_entity, entity

        harvest_entity.harvest_contributions.find_each do |harvest_contribution|
          yield attach_contribution.call(harvest_contribution, entity)
        end

        # Descend 1 level and attach the current `harvest_entity`'s children
        # as children of the recently-created `entity`.
        harvest_entity.children.find_each do |child|
          yield attach! child, parent: entity
        end

        Success entity
      end

      # @!group Steps

      # @param [HarvestEntity] harvest_entity
      # @param [Collection, Item] entity
      # @return [Dry::Monads::Result]
      def apply_attributes!(harvest_entity, entity)
        entity.assign_attributes harvest_entity.extracted_attributes

        Success nil
      end

      def assign_schema_version!(harvest_entity, entity)
        entity.schema_version = harvest_entity.schema_version

        return Success(nil) if entity.schema_version.present?

        # Default fallback
        case entity
        when ::Collection
          entity.schema_version = schemas[:default_collection]

          Success nil
        when ::Item
          entity.schema_version = schemas[:default_item]

          Success nil
        else
          # :nocov:
          Failure[:invalid_entity, "Cannot set schema version for #{entity.inspect}"]
          # :nocov:
        end
      end

      # @see Harvesting::Entities::AttachAssets
      # @param [HarvestEntity] harvest_entity
      # @param [Collection, Item] entity
      # @return [Dry::Monads::Success(PropertyHash)]
      def apply_assets!(harvest_entity, entity)
        # Entities must be saved in order to apply assets. It should save safely here.
        yield monadic_save entity

        attach_assets.call entity, harvest_entity.extracted_assets
      end

      # @see Schemas::Instances::Apply
      # @param [HarvestEntity] harvest_entity
      # @param [Collection, Item] entity
      # @param [PropertyHash] assets
      # @return [Dry::Monads::Result]
      def apply_schema_version_and_properties!(harvest_entity, entity, assets: PropertyHash.new)
        # We need the schema version and everything else to be applied
        yield monadic_save entity

        props = PropertyHash.new(harvest_entity.extracted_properties) | assets

        apply_properties.call entity, props.to_h
      end

      # Attach the upserted entity to the {HarvestEntity} for later introspection and record-keeping.
      #
      # @param [HarvestEntity] harvest_entity
      # @param [Collection, Item] entity
      # @return [Dry::Monads::Result]
      def finalize!(harvest_entity, entity)
        harvest_entity.entity = entity

        monadic_save harvest_entity
      end

      # @!endgroup

      # Using {#scope_for}, this will find or initialize an entity within the expected scope
      # of the hierarchy based on the {HarvestEntity}'s `identifier`.
      #
      # @param [Collection, Item] parent
      # @param [HarvestEntity] harvest_entity
      # @return [Collection, Item]
      def find_or_initialize_entity_for(parent, harvest_entity)
        scope = yield scope_for parent, harvest_entity

        Success scope.by_identifier(harvest_entity.identifier).first_or_initialize
      end

      # Based on the provided parent and harvest_entity, return the correct scope
      # to be consumed by {#find_or_initialize_entity_for}.
      #
      # @return [Dry::Monads::Success(ActiveRecord::Relation)]
      # @return [Dry::Monads::Failure]
      def scope_for(parent, harvest_entity)
        parent_type = yield type_for parent

        child_type = yield type_for harvest_entity

        case [parent_type, child_type]
        when [:collection, :item]
          Success parent.items
        when [:collection, :collection], [:item, :item]
          Success parent.children
        else
          # :nocov:
          Failure[:invalid_parentage, "cannot create child of type #{child_type} under #{parent_type}"]
          # :nocov:
        end
      end

      # Used by {#scope_for} to derive the right scope based on the provided model.
      #
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
          type_from_harvest_entity model
        else
          # :nocov:
          Failure[:unknown_type, "Cannot derive entity type from #{model.inspect}"]
          # :nocov:
        end
      end

      # @see #type_for
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

      # @see #type_for
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
