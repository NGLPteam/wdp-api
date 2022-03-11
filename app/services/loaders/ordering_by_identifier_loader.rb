# frozen_string_literal: true

module Loaders
  # An ability to calculate the _currently_ visible entries for multiple
  # {Ordering} instances at query time.
  class OrderingByIdentifierLoader < GraphQL::Batch::Loader
    # @param [String] identifier
    def initialize(identifier)
      @identifier = identifier
    end

    # @param [<HierarchicalEntity>] entities
    def perform(entities)
      Ordering.by_entity(entities).by_identifier(@identifier).find_each do |ordering|
        fulfill(ordering, ordering)
      end
    end

    # @param [HierarchicalEntity, Ordering] record
    def cache_key(record)
      case record
      when ::Ordering
        record.entity_id
      else
        record.id
      end
    end
  end
end
