# frozen_string_literal: true

module Loaders
  # An ability to calculate the _currently_ visible entries for multiple
  # {Ordering} instances at query time.
  class OrderingEntryCountLoader < GraphQL::Batch::Loader
    UUID_V4 = Support::GlobalTypes::String.constrained(uuid_v4: true)

    # @param [<Ordering>] orderings
    def perform(orderings)
      counts = OrderingEntry.visible_count_for orderings

      counts.each do |ordering_id, count|
        fulfill ordering_id, count
      end

      orderings.each do |ordering|
        next if fulfilled? ordering

        fulfill ordering, 0
      end
    end

    # @param [Ordering, String] object
    def cache_key(object)
      case object
      when UUID_V4
        object
      when ::Ordering
        object.id
      else
        # :nocov:
        raise TypeError, "Cannot load entry counts for #{object.inspect}"
        # :nocov:
      end
    end
  end
end
