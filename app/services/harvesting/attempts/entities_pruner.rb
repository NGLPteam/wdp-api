# frozen_string_literal: true

module Harvesting
  module Attempts
    # @see Harvesting::Attempts::PruneEntities
    class EntitiesPruner < Harvesting::Utility::AbstractEntitiesPruner
      param :harvest_attempt, Types::Attempt

      delegate :harvest_source, to: :harvest_record

      around_execute :provide_harvest_attempt!
      around_execute :provide_harvest_source!

      def prune
        harvest_attempt.harvest_records.find_each do |harvest_record|
          counts = yield harvest_record.prune_entities(mode:)

          absorb!(**counts)
        end

        super
      end
    end
  end
end
