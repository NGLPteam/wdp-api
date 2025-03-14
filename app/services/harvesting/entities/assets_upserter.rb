# frozen_string_literal: true

module Harvesting
  module Entities
    # This service is used to upload assets and attach them to properties
    # **after** {Harvesting::Entities::Upsert the entity has been upserted}.
    #
    # We do this in a separate step owing to the unreliability of upstream
    # sources, so that we can cache harvested assets across harvesting runs,
    # and so asset failures do not preclude entities being visible.
    # @see Harvesting::Entities::UpsertAssets
    class AssetsUpserter < Support::HookBased::Actor
      include Dry::Initializer[undefined: false].define -> do
        param :harvest_entity, Harvesting::Types::Entity
      end

      include Harvesting::Middleware::ProvidesHarvestData
      include Harvesting::WithLogger

      # Harvest error codes that are cleared by this operation.
      CLEARABLE_CODES = %i[
        asset_not_found
        could_not_upsert_assets
        failed_asset_upsert
        failed_entity_upsert
        invalid_entity_asset
      ].freeze

      standard_execution!

      delegate :harvest_record, :has_assets?, :has_entity?, to: :harvest_entity

      delegate :harvest_configuration, to: :harvest_record

      delegate :harvest_attempt, to: :harvest_configuration, allow_nil: true

      around_execute :provide_harvest_entity!

      around_execute :provide_harvest_record!

      around_execute :provide_harvest_configuration!

      around_execute :provide_harvest_attempt!

      # @return [HierarchicalEntity]
      attr_reader :entity

      # @return [Harvesting::Assets::Mapping]
      attr_reader :extracted_assets

      # @return [{ String => Asset, <Asset> }]
      attr_reader :asset_properties

      # @return [Dry::Monads::Success(void)]
      def call
        run_callbacks :execute do
          yield prepare!

          yield upsert_all_assets!

          yield write_asset_properties!
        end

        Success()
      end

      wrapped_hook! def prepare
        harvest_entity.clear_harvest_errors!(*CLEARABLE_CODES)

        @asset_properties = {}

        @entity = harvest_entity.entity

        @extracted_assets = harvest_entity.extracted_assets

        # :nocov:
        logger.warn("Tried to upsert assets for a harvested entity with no assets") unless has_assets?

        logger.warn("Tried to upsert assets for a harvested entity that has not finished harvesting") unless has_entity?
        # :nocov:

        super
      end

      wrapped_hook! def upsert_all_assets
        return super unless has_entity? && has_assets?

        upsert_and_attach!.or do |reason|
          harvest_entity.log_harvest_error!(*harvest_entity.to_failed_upsert(reason, code: :failed_asset_upsert))
        end
      rescue Harvesting::Error => e
        # :nocov:
        logger.error e.message

        harvest_entity.log_harvest_error! :could_not_upsert_assets, e.message, exception_klass: e.class.name, backtrace: e.backtrace

        super
        # :nocov:
      else
        super
      end

      wrapped_hook! def write_asset_properties
        asset_properties.each do |path, value|
          entity.write_property(path, value).or do
            # :nocov:
            logger.error "Failed to store asset property: #{path}"
            # :nocov:
          end
        end

        super
      end

      private

      # @return [Dry::Monads::Success(void)]
      def upsert_and_attach!
        entity.attach_harvested_assets(extracted_assets).tap do |result|
          @asset_properties = result.value_or({})
        end
      end
    end
  end
end
