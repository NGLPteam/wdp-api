# frozen_string_literal: true

module Harvesting
  module Entities
    # @see Harvesting::Entities::Upsert
    class Upserter < Support::HookBased::Actor
      include Dry::Initializer[undefined: false].define -> do
        param :harvest_entity, Harvesting::Types::Entity
      end

      include Dry::Matcher.for(:patch_properties, with: Dry::Matcher::ResultMatcher)
      include Harvesting::Middleware::ProvidesHarvestData
      include Harvesting::WithLogger
      include MeruAPI::Deps[
        attach_contribution: "harvesting.contributions.attach",
        connect_link: "links.connect",
        find_existing_collection: "harvesting.utility.find_existing_collection",
      ]

      delegate :has_existing_parent?, :existing_parent, to: :harvest_entity

      # @return [String]
      attr_reader :advisory_key

      # @return [ChildEntity]
      attr_reader :current_entity

      # @return [HarvestEntity]
      attr_reader :current_harvest_entity

      # @return [HarvestTarget, nil]
      attr_reader :default_target_entity

      # @return [HarvestConfiguration, nil]
      attr_reader :harvest_configuration

      # @return [HarvestRecord]
      attr_reader :harvest_record

      # @return [HarvestTarget, nil]
      attr_reader :root_parent

      # @return [<HarvestEntity>]
      attr_reader :with_assets

      delegate :harvest_attempt, to: :harvest_configuration, allow_nil: true

      standard_execution!

      around_execute :refresh_orderings_asynchronously!

      around_execute :provide_harvest_entity!

      around_execute :provide_harvest_record!

      around_execute :provide_harvest_configuration!

      around_execute :provide_harvest_attempt!

      # @return [Dry::Monads::Result]
      def call
        run_callbacks :execute do
          yield prepare!

          yield upsert_root!

          yield enqueue_assets_jobs!
        end

        Success()
      end

      wrapped_hook! def prepare
        harvest_entity.clear_harvest_errors!

        @harvest_record = harvest_entity.harvest_record

        @harvest_configuration = harvest_record.harvest_configuration

        # Harvest configurations can be nil during the migration period
        @default_target_entity = harvest_configuration.try(:target_entity)

        @root_parent = has_existing_parent? ? existing_parent : default_target_entity

        @with_assets = []

        @current_entity = nil

        @current_harvest_entity = harvest_entity

        @advisory_key = harvest_entity.identifier

        super
      end

      wrapped_hook! def upsert_root
        # :nocov:
        if @root_parent.nil?
          logger.fatal "Could not derive root parent (missing harvest configuration?)."

          return super
        end

        unless harvest_entity.root?
          logger.fatal "Must be a root harvest entity"

          return super
        end
        # :nocov:

        attach! harvest_entity, parent: root_parent
      rescue Harvesting::Error => e
        logger.error e.message

        harvest_entity.log_harvest_error! :entity_upsert_failure, e.message, exception_klass: e.class.name, backtrace: e.backtrace

        Success nil
      else
        Success nil
      end

      wrapped_hook! def enqueue_assets_jobs
        with_assets.each do |asset_entity|
          Harvesting::Entities::UpsertAssetsJob.set(wait: 10.seconds).perform_later asset_entity
        end

        super
      end

      private

      # @param [HarvestEntity] harvest_entity
      # @param [HierarchicalEntity] parent
      # @return [Dry::Monads::Success(void)]
      do_for! def attach!(harvest_entity, parent:)
        @current_harvest_entity = harvest_entity

        # @note Temporarily disabled while troubleshooting job lockup issues
        @advisory_key = [parent.identifier, harvest_entity.identifier].join(?:)

        with_harvest_entity current_harvest_entity do
          # ApplicationRecord.with_advisory_lock advisory_key do
          entity = yield find_current_entity_for!(harvest_entity, parent:)

          maybe_apply_data!
          # end

          finalize_connection!

          yield attach_contributions!(harvest_entity, entity:)

          yield attach_children!(harvest_entity, parent: entity)

          yield upsert_links! harvest_entity, harvest_entity.entity
        end

        Success nil
      end

      # Descend 1 level and attach the current `harvest_entity`'s children
      # as children of the recently-created `entity`.
      #
      # @param [HarvestEntity] harvest_entity
      # @param [HierarchicalEntity] parent
      # @return [Dry::Monads::Success(void)]
      do_for! def attach_children!(harvest_entity, parent:)
        harvest_entity.children.find_each do |child|
          logger.trace "attaching child (#{child.identifier}) to #{parent.identifier}"

          yield attach!(child, parent:)
        ensure
          # Re-assign the current entity back after each attached child
          @current_entity = parent
        end

        Success()
      end

      # @param [HarvestEntity] harvest_entity
      # @param [HierarchicalEntity] entity
      # @return [Dry::Monads::Success(void)]
      do_for! def attach_contributions!(harvest_entity, entity:)
        harvest_entity.harvest_contributions.find_each do |harvest_contribution|
          yield attach_contribution.call(harvest_contribution, entity)
        end

        Success()
      end

      # @return [void]
      def finalize_connection!
        # :nocov:
        return unless current_entity.try(:persisted?)
        # :nocov:

        current_harvest_entity.entity = current_entity

        current_harvest_entity.save!(validate: false)
      end

      # @param [HarvestEntity] harvest_entity
      # @param [HierarchicalEntity] parent
      # @return [Dry::Monads::Success(HierarchicalEntity)]
      def find_current_entity_for!(harvest_entity, parent:)
        entity = parent.find_or_initialize_harvested_child_for(harvest_entity)

        @current_entity = entity

        Success entity
      end

      # @param [HasHarvestModificationStatus] entity
      def modifiable?(entity)
        entity.new_record? || entity.pristine_for_harvest?
      end

      # @return [void]
      def maybe_apply_data!
        return unless modifiable?(current_entity)

        current_entity.harvest_modification_status = "pristine"

        current_entity.schema_version = current_harvest_entity.schema_version

        current_entity.assign_attributes current_harvest_entity.attributes_to_assign

        # Saving the entity should work at this point, and we need it to be persisted now.
        current_entity.save!

        patch_properties do |m|
          m.success do
            # Re-save to reload after applying all properties.
            current_entity.save!

            with_assets << current_harvest_entity if current_harvest_entity.has_assets?
          end

          m.failure(:invalid_values) do |_, result|
            log_validation_failures!(result)
          end

          m.failure do |*error|
            # :nocov:
            logger.fatal("could not write properties for unknown reason", tags: %w[unknown_property_write_failure], error:)
            # :nocov:
          end
        end

        return
      end

      # @param [Dry::Validation::Result] result
      # @return [void]
      def log_validation_failures!(result)
        result.errors.each do |error|
          log_validation_failure! error
        end
      end

      # @param [Dry::Validation::Message] error
      # @return [void]
      def log_validation_failure!(error)
        human_path = error.path.map { "[#{_1.inspect}]" }.join

        logger.error "failed to write `entity#{human_path}`: #{error.text}", tags: ["invalid_property", human_path], path: error.path
      end

      def patch_properties
        current_entity.patch_properties(current_harvest_entity.extracted_properties)
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

      # @return [void]
      def refresh_orderings_asynchronously!
        Schemas::Orderings.with_asynchronous_refresh do
          yield
        end
      end

      # @param [HarvestEntity] harvest_entity
      # @param [ChildEntity] entity
      # @return [Dry::Monads::Success(void)]
      do_for! def upsert_links!(harvest_entity, entity)
        harvest_entity.extracted_links.incoming_collections.each do |source|
          collection = existing_collection_from! source.identifier

          yield connect_link.call(collection, entity, source.operator)
        end

        Success()
      end
    end
  end
end
