# frozen_string_literal: true

module Schemas
  module Instances
    # An operation that handles refreshing all orderings associated with a specific entity.
    #
    # @see Schemas::Orderings::RefreshStatus
    class RefreshOrderings
      include Dry::Effects.Resolve(:refresh_status)
      include Dry::Monads[:do, :result]
      include MonadicPersistence

      include MeruAPI::Deps[refresh: "schemas.orderings.refresh"]

      # @param [HierarchicalEntity] entity
      # @return [Dry::Monads::Result]
      def call(entity)
        status = refresh_status { Schemas::Orderings::RefreshStatus.new }

        return Success() if status.disabled? || status.skip?(entity)

        Ordering.owned_by_or_ordering(entity).find_each do |ordering|
          next if status.skip?(ordering)

          next unless ordering.refreshes_for? entity

          if status.deferred? || status.async?
            ordering.invalidate!
          else
            yield refresh.(ordering)
          end
        end

        return Success()
      end
    end
  end
end
