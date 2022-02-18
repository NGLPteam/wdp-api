# frozen_string_literal: true

module Types
  class AnyResolvedEntityType < Types::BaseUnion
    possible_types Types::CommunityType, Types::CollectionType, Types::ItemType

    description <<~TEXT
    Much like `AnyEntityType`, this represents any of the system's hierarchical
    entities. It is separated out because it can have some extra serverside
    processing in order to "resolve" the entities, usually as a result of
    searching or calculating advanced scopes.
    TEXT

    class << self
      # @param [<HierarchicalEntity, Entity, EntityDescendant>] entities
      # @return [<HierarchicalEntity>]
      def scope_items(entities, context)
        Array(entities).map do |entity|
          case entity
          when ::HierarchicalEntity then entity
          when ::Entity then entity.hierarchical
          when ::EntityDescendant then entity.descendant
          end
        end.compact
      end
    end
  end
end
