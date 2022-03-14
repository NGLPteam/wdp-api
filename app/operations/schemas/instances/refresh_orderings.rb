# frozen_string_literal: true

module Schemas
  module Instances
    # An operation that handles refreshing all orderings associated with a specific entity.
    #
    # @see Schemas::Orderings::RefreshStatus
    class RefreshOrderings
      include Dry::Effects.Defer
      include Dry::Effects.Resolve(:refresh_status)
      include Dry::Monads[:do, :result]
      include MonadicPersistence

      include WDPAPI::Deps[refresh: "schemas.orderings.refresh", calculate_initial: "schemas.orderings.calculate_initial"]

      # @param [HierarchicalEntity] entity
      # @return [Dry::Monads::Result]
      def call(entity)
        status = refresh_status { Schemas::Orderings::RefreshStatus.new }

        return Success() if status.disabled? || status.skip?(entity)

        Ordering.owned_by_or_ordering(entity).find_each do |ordering|
          next if status.skip?(ordering)

          if status.harvesting?
            later do
              Schemas::Orderings::RefreshJob.perform_later ordering
            end
          elsif status.async?
            Schemas::Orderings::RefreshJob.perform_later ordering
          else
            yield refresh.(ordering)
          end
        end

        if status.deferred? || status.async?
          later do
            Schemas::Orderings::CalculateInitialJob.set(wait: 2.minutes).perform_later(entity: entity)
          end
        elsif status.async?
          Schemas::Orderings::CalculateInitialJob.set(wait: 2.minutes).perform_later(entity: entity)
        else
          yield calculate_initial.(entity: entity)
        end

        return Success()
      end
    end
  end
end
