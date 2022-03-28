# frozen_string_literal: true

module Loaders
  # An ability to calculate the _currently_ visible entries for multiple
  # {Ordering} instances at query time.
  class OrderingBySchemaLoader < GraphQL::Batch::Loader
    # @param [String] slug
    def initialize(slug)
      @slug = slug
    end

    # @param [<HierarchicalEntity>] entities
    def perform(entities)
      Ordering.by_entity(entities).by_handled_schema_definition(@slug).find_each do |ordering|
        fulfill(ordering, ordering)
      end

      entities.each do |entity|
        fulfill(entity, nil) unless fulfilled?(entity)
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
