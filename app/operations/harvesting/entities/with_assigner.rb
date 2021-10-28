# frozen_string_literal: true

module Harvesting
  module Entities
    class WithAssigner
      include MonadicPersistence

      # @param [HarvestEntity] harvest_entity
      # @yield [assigner] Yield an assignment to a specific entity
      # @yieldparam [Harvesting::Entities::Assigner] assigner
      # @yieldreturn [void]
      # @return [Dry::Monads::Result] whether the harvest entity was successfully saved
      def call(harvest_entity)
        assigner = Harvesting::Entities::Assigner.new

        yield assigner if block_given?

        harvest_entity.assign_attributes assigner.to_attributes

        monadic_save harvest_entity
      end
    end
  end
end
