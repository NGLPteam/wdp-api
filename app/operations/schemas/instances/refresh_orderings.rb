# frozen_string_literal: true

module Schemas
  module Instances
    class RefreshOrderings
      include Dry::Effects.Resolve(:harvest_attempt)
      include Dry::Monads[:do, :result]
      include MonadicPersistence

      include WDPAPI::Deps[refresh: "schemas.orderings.refresh"]

      # @param [HierarchicalEntity] entity
      # @return [Dry::Monads::Result]
      def call(entity)
        currently_harvesting = harvest_attempt { nil }.present?

        Ordering.owned_by_or_ordering(entity).find_each do |ordering|
          if currently_harvesting
            # We need to enqueue this job when harvesting instead of trying
            # to update all orderings immediately.
            Schemas::Orderings::RefreshJob.perform_later ordering
          else
            yield refresh.call(ordering)
          end
        end

        Success nil
      end
    end
  end
end
