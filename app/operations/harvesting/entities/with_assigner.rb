# frozen_string_literal: true

module Harvesting
  module Entities
    class WithAssigner
      include MonadicPersistence
      include Dry::Effects.State(:extracted_entity_ids)

      # @param [HarvestEntity] harvest_entity
      # @yield [assigner] Yield an assignment to a specific entity
      # @yieldparam [Harvesting::Entities::Assigner] assigner
      # @yieldreturn [void]
      # @return [Dry::Monads::Result] whether the harvest entity was successfully saved
      def call(harvest_entity)
        assigner = Harvesting::Entities::Assigner.new

        yield assigner if block_given?

        harvest_entity.assign_attributes assigner.to_attributes

        monadic_save(harvest_entity).tap do |result|
          result.bind do |record|
            extracted_entity_ids << record.id
          end
        end
      end
    end
  end
end
