# frozen_string_literal: true

module Schemas
  module Instances
    # Find an {OrderingEntry} for a given {HierarchicalEntity} within an {Ordering}.
    #
    # @see Ordering#find_entry
    # @see Schemas::Orderings::FindEntry
    class FindOrderingEntry
      include Dry::Monads[:result, :maybe]

      include MeruAPI::Deps[
        find_entry: "schemas.orderings.find_entry",
      ]

      # @param [HierarchicalEntity] source the source entity that might have the `identifier`-named ordering
      # @param [String] identifier the name of an ordering (@see HierarchicalEntity#ordering)
      # @param [HierarchicalEntity] target
      # @return [Dry::Monads::Success(OrderingEntry)]
      # @return [Dry::Monads::Failure(:ordering_entry_not_found)]
      def call(source, identifier, target)
        ordering = source.ordering(identifier)

        find_entry.(ordering, target)
      end
    end
  end
end
