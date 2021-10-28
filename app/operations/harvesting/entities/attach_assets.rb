# frozen_string_literal: true

module Harvesting
  module Entities
    # Takes an {Attachable entity} and a {Harvesting::Assets::Mapping mapping of assets} to
    # attach, as well as to generate a {PropertyHash} for schematically-associated assets that
    # can be used later
    class AttachAssets
      include Dry::Monads[:do, :result]
      include WDPAPI::Deps[
        attach_asset: "harvesting.entities.attach_asset",
      ]

      # @param [Attachable] entity
      # @param [Harvest::Assets::Mapping] mapping
      # @return [Dry::Monads::Success(PropertyHash)]
      # @return [Dry::Monads::Failure]
      def call(entity, mapping)
        return Success(PropertyHash.new) if mapping.blank?

        yield attach_unassociated_assets! entity, mapping

        @properties = PropertyHash.new

        yield attach_scalar_assets! entity, mapping

        yield attach_collected_assets! entity, mapping

        Success @properties
      ensure
        @properties = nil
      end

      private

      # @param [Attachable] entity
      # @param [Harvest::Assets::Mapping] mapping
      # @return [void]
      def attach_unassociated_assets!(entity, mapping)
        mapping.unassociated.each do |source|
          yield attach_asset.call(entity, source)
        end

        Success nil
      end

      # @param [Attachable] entity
      # @param [Harvest::Assets::Mapping] mapping
      # @return [void]
      def attach_scalar_assets!(entity, mapping)
        mapping.scalar.each do |scalar|
          @properties[scalar.full_path] = yield attach_asset.call(entity, scalar.asset)
        end

        Success nil
      end

      # @param [Attachable] entity
      # @param [Harvest::Assets::Mapping] mapping
      # @return [void]
      def attach_collected_assets!(entity, mapping)
        mapping.collected.each do |collected|
          @properties[collected.full_path] = collected.assets.map do |asset|
            yield attach_asset.call(entity, asset)
          end
        end

        Success nil
      end
    end
  end
end
