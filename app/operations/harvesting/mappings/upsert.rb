# frozen_string_literal: true

module Harvesting
  module Mappings
    class Upsert
      include MonadicPersistence

      # @param [HarvestSource] harvest_source
      # @param [HarvestTarget] target_entity
      # @param [HarvestSet, nil] set
      # @param [Hash] options
      # @return [Dry::Monads::Success(HarvestMapping)]
      def call(harvest_source, target_entity, set: nil, **options)
        mapping = harvest_source.harvest_mappings.by_target(target_entity).by_set(set).first_or_initialize do |to_create|
          to_create.inherit_harvesting_options_from! harvest_source
        end

        mapping.merge_harvesting_options!(**options)

        monadic_save mapping
      end
    end
  end
end
