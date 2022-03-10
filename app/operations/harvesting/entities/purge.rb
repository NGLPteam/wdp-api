# frozen_string_literal: true

module Harvesting
  module Entities
    # Remove an existing harvest entity (if metadata changed or otherwise caused the record to be skipped).
    class Purge
      include Dry::Monads[:result, :do]

      # @param [HarvestEntity] harvest_entity
      # @return [Dry::Monads::Success]
      def call(harvest_entity)
        yield preprocess! harvest_entity

        yield remove_existing! harvest_entity

        harvest_entity.destroy

        Success()
      end

      private

      # @param [HarvestEntity] harvest_entity
      # @return [Dry::Monads::Success]
      def preprocess!(harvest_entity)
        harvest_entity.children.find_each do |child|
          call child
        end

        Success()
      end

      # @todo This should validate that the entity was purged somehow
      # @param [HarvestEntity] harvest_entity
      # @return [Dry::Monads::Success]
      def remove_existing!(harvest_entity)
        harvest_entity.entity.try(:destroy)

        Success()
      end
    end
  end
end
