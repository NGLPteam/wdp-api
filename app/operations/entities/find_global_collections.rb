# frozen_string_literal: true

module Entities
  # Find the scope for global collections
  class FindGlobalCollections
    # @param [HierarchicalEntity] entity
    # @return [ActiveRecord::Relation<Collection>]
    def call(entity)
      case entity
      when ::Community
        entity.collections
      when ::Collection, ::Item
        call entity.community
      else
        # :nocov:
        Collection.none
        # :nocov:
      end
    end
  end
end
