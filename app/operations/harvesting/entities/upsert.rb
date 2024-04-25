# frozen_string_literal: true

module Harvesting
  module Entities
    # This operation transforms a (root) {HarvestEntity} and all its descendants
    # into a set of {Collection collections} or {Item items}, based on the assigned
    # {SchemaVersion schema}. If the associated {HarvestEntity} has not set a schema,
    # it will fall back to an `default:item`.
    class Upsert
      include Dry::Monads[:do, :result]
      include Dry::Effects.Resolve(:target_entity)
      include Dry::Effects.Resolve(:schemas)
      include MonadicPersistence
      include MeruAPI::Deps[
        apply_properties: "schemas.instances.apply",
        attach_contribution: "harvesting.contributions.attach",
        connect_link: "links.connect",
        find_existing_collection: "harvesting.utility.find_existing_collection",
      ]

      # @param [HarvestEntity] entity
      # @return [Dry::Monads::Success(ChildEntity)] the root {HarvestEntity}'s associated entity
      def call(harvest_entity)
        harvest_entity.clear_harvest_errors!

        upsert_root(harvest_entity).tap do |result|
          result.or do |reason|
            harvest_entity.log_harvest_error!(*harvest_entity.to_failed_upsert(reason))
          end
        end
      rescue Harvesting::Error => e
        harvest_entity.log_harvest_error! :could_not_upsert_entity, e.message, exception_klass: e.class.name, backtrace: e.backtrace

        Failure[:failed_upsert, e.message]
      end

      private

      # @note The provided harvest entity must be `root` or else it would cause incongruent
      #   upsertions: something intended at the second level relative to the initial {HarvestTarget}
      #   would be right under it instead.
      # @param [HarvestEntity] entity
      # @return [Dry::Monads::Success(ChildEntity)] the root {HarvestEntity}'s associated entity
      def upsert_root(harvest_entity)
        return Failure[:must_be_root, "The provided entity to upsert must be a root"] unless harvest_entity.root?

        entity = yield attach! harvest_entity, parent: root_parent_for(harvest_entity)

        Success entity
      end

      def attach!(harvest_entity, parent:)
        advisory_key = [parent.identifier, harvest_entity.identifier].join(":")

        entity = nil

        ApplicationRecord.with_advisory_lock advisory_key do
          entity = yield find_or_initialize_entity_for parent, harvest_entity

          yield apply_attributes! harvest_entity, entity

          yield assign_schema_version! harvest_entity, entity

          # This will not include asset properties.
          yield apply_schema_version_and_properties!(harvest_entity, entity)

          yield finalize! harvest_entity, entity
        end

        harvest_entity.harvest_contributions.find_each do |harvest_contribution|
          yield attach_contribution.call(harvest_contribution, entity)
        end

        # Descend 1 level and attach the current `harvest_entity`'s children
        # as children of the recently-created `entity`.
        harvest_entity.children.find_each do |child|
          yield attach! child, parent: entity
        end

        yield upsert_links! harvest_entity, entity

        Harvesting::UpsertEntityAssetsJob.perform_later harvest_entity if harvest_entity.has_assets?

        Success entity
      end

      # @param [HarvestEntity] harvest_entity
      # @return [HarvestTarget]
      def root_parent_for(harvest_entity)
        harvest_entity.has_existing_parent? ? harvest_entity.existing_parent : target_entity
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

      # @see Schemas::Instances::Apply
      # @param [HarvestEntity] harvest_entity
      # @param [Collection, Item] entity
      # @param [PropertyHash] assets
      # @return [Dry::Monads::Result]
      def apply_schema_version_and_properties!(harvest_entity, entity)
        # We need the schema version and everything else to be applied
        yield monadic_save entity

        props = PropertyHash.new(harvest_entity.extracted_properties)

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
        if harvest_entity.entity.present?
          existing_entity = harvest_entity.entity

          existing_entity.identifier = harvest_entity.identifier

          Success existing_entity
        else
          scope = yield scope_for parent, harvest_entity

          Success scope.by_identifier(harvest_entity.identifier).first_or_initialize
        end
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
        when [:community, :collection]
          Success parent.collections
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
        when ::Community
          Success :community
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

      # @param [String, nil] identifier
      # @return [Collection, nil]
      def existing_collection_from!(identifier)
        find_existing_collection.(identifier)
      rescue ActiveRecord::RecordNotFound
        raise Harvesting::Metadata::Error, "Unknown existing collection: #{identifier}"
      rescue LimitToOne::TooManyMatches
        raise Harvesting::Metadata::Error, "Tried to link non-global identifier: #{identifier}"
      end

      # @param [HarvestEntity] harvest_entity
      # @param [ChildEntity] entity
      def upsert_links!(harvest_entity, entity)
        harvest_entity.extracted_links.incoming_collections.each do |source|
          collection = existing_collection_from! source.identifier

          yield connect_link.call(collection, entity, source.operator)
        end

        Success()
      end
    end
  end
end
