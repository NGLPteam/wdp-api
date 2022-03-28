# frozen_string_literal: true

module Loaders
  # Grab an {OrderingEntry} by a specific {Entity} for a specific {Ordering}
  class OrderingEntryLoader < GraphQL::Batch::Loader
    # @param [Ordering] ordering
    def initialize(ordering)
      @ordering = ordering
    end

    # @param [<HierarchicalEntity>] entities
    def perform(entities)
      @ordering.ordering_entries.by_entity(entities).find_each do |entry|
        fulfill(entry, entry)
      end

      entities.each do |entity|
        fulfill(key, nil) unless fulfilled?(entity)
      end
    end

    # @param [HierarchicalEntity, OrderingEntry] record
    def cache_key(record)
      case record
      when ::OrderingEntry
        record.entity_id
      else
        record.id
      end
    end
  end
end
