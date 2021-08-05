# frozen_string_literal: true

module Schemas
  module Instances
    class RefreshOrderings
      include Dry::Monads[:do, :result]
      include MonadicPersistence

      include WDPAPI::Deps[refresh: "schemas.orderings.refresh"]

      prepend TransactionalCall

      # @param [HierarchicalEntity] entity
      # @return [Dry::Monads::Result]
      def call(entity)
        Ordering.owned_by_or_ordering(entity).find_each do |ordering|
          yield refresh.call(ordering)
        end

        Success nil
      end
    end
  end
end
