# frozen_string_literal: true

module Harvesting
  module Entities
    # This operation is used to upload assets and attach them to properties
    # **after** {Harvesting::Entities::Upsert the entity has been upserted}.
    #
    # We do this in a separate step owing to the unreliability of upstream
    # sources, so that we can cache harvested assets across harvesting runs,
    # and so asset failures do not preclude entities being visible.
    class UpsertAssets
      include Dry::Effects::Handler.Resolve
      include Dry::Monads[:do, :result]
      include MonadicPersistence
      include MeruAPI::Deps[
        add_reference: "harvesting.cached_assets.reference",
        apply_properties: "schemas.instances.apply",
        attach_assets: "harvesting.entities.attach_assets",
      ]

      # Harvest error codes that are cleared by this operation.
      CLEARABLE_CODES = %i[
        asset_not_found could_not_upsert_assets failed_asset_upsert
        failed_entity_upsert invalid_entity_asset
      ].freeze

      # @param [HarvestEntity] entity
      # @return [Dry::Monads::Result]
      def call(harvest_entity)
        harvest_entity.clear_harvest_errors!(*CLEARABLE_CODES)

        return Failure[:missing_entity, harvest_entity] unless harvest_entity.has_entity?

        return Success() unless harvest_entity.has_assets?

        upsert_and_attach!(harvest_entity).or do |reason|
          harvest_entity.log_harvest_error!(*harvest_entity.to_failed_upsert(reason, code: :failed_asset_upsert))

          Success()
        end
      rescue Harvesting::Error => e
        harvest_entity.log_harvest_error! :could_not_upsert_assets, e.message, exception_klass: e.class.name, backtrace: e.backtrace

        Failure[:failed_upsert, e.message]
      end

      private

      # @param [HarvestEntity] harvest_entity
      # @return [Dry::Monads::Result]
      def upsert_and_attach!(harvest_entity)
        asset_properties = yield apply_assets! harvest_entity

        yield apply_schema_version_and_properties!(harvest_entity, assets: asset_properties)

        Success harvest_entity
      end

      # @see Harvesting::Entities::AttachAssets
      # @param [HarvestEntity] harvest_entity
      # @return [Dry::Monads::Success(PropertyHash)] a hash of schema properties to assign
      def apply_assets!(harvest_entity)
        provide(harvest_entity:) do
          attach_assets.call harvest_entity.entity, harvest_entity.extracted_assets
        end
      end

      # @see Schemas::Instances::Apply
      # @param [HarvestEntity] harvest_entity
      # @param [Collection, Item] entity
      # @param [PropertyHash] assets
      # @return [Dry::Monads::Result]
      def apply_schema_version_and_properties!(harvest_entity, assets: PropertyHash.new)
        props = PropertyHash.new(harvest_entity.extracted_properties) | assets

        apply_properties.call harvest_entity.entity, props.to_h
      end
    end
  end
end
