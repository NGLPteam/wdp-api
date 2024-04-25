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

      include MeruAPI::Deps[refresh: "schemas.orderings.refresh", calculate_initial: "schemas.orderings.calculate_initial"]

      # @param [HierarchicalEntity] entity
      # @return [Dry::Monads::Result]
      def call(entity)
        status = refresh_status { Schemas::Orderings::RefreshStatus.new }

        return Success() if status.disabled? || status.skip?(entity)

        Ordering.owned_by_or_ordering(entity).find_each do |ordering|
          next if status.skip?(ordering)

          next unless ordering.refreshes_for? entity

          if status.deferred?
            later do
              Schemas::Orderings::RefreshJob.perform_later ordering
            end
          elsif status.async?
            Schemas::Orderings::RefreshJob.perform_later ordering
          else
            yield refresh.(ordering)
          end
        end

        yield calculate_initial.(entity:) if entity.orderings.exists?

        return Success()
      end
    end
  end
end
