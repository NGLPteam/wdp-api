# frozen_string_literal: true

module Harvesting
  module Sources
    # @see Harvesting::Sources::PruneEntities
    class EntitiesPruner < Harvesting::Utility::AbstractEntitiesPruner
      param :harvest_source, Types::Source

      around_execute :provide_harvest_source!

      def prune
        harvest_source.harvest_records.find_each do |harvest_record|
          counts = yield harvest_record.prune_entities(mode:)

          absorb!(**counts)
        end

        super
      end
    end
  end
end
