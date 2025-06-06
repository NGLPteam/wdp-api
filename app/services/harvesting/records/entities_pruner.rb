# frozen_string_literal: true

module Harvesting
  module Records
    # @see Harvesting::Records::PruneEntities
    class EntitiesPruner < Harvesting::Utility::AbstractEntitiesPruner
      param :harvest_record, Types::Record

      delegate :harvest_source, to: :harvest_record

      around_execute :provide_harvest_source!
      around_execute :provide_harvest_record!

      def prune
        harvest_record.harvest_entities.roots.find_each do |harvest_entity|
          counts = yield harvest_entity.prune_entities(mode:)

          absorb!(**counts)
        end
      end
    end
  end
end
