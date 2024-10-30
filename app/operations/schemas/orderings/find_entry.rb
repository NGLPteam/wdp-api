# frozen_string_literal: true

module Schemas
  module Orderings
    # Find an {OrderingEntry} for a given {HierarchicalEntity} within an {Ordering}.
    #
    # @see Ordering#find_entry
    class FindEntry
      include Dry::Monads[:result, :maybe]

      # @param [Ordering] ordering
      # @param [HierarchicalEntity] entity
      # @return [Dry::Monads::Success(OrderingEntry)]
      # @return [Dry::Monads::Failure(:ordering_missing)]
      # @return [Dry::Monads::Failure(:ordering_entry_not_found)]
      def call(ordering, entity)
        return Failure[:ordering_missing] if ordering.blank?

        Maybe(ordering.ordering_entries.find_by(entity:)).to_result.or do
          Failure[:ordering_entry_not_found]
        end
      end
    end
  end
end
