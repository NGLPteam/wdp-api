# frozen_string_literal: true

module Templates
  module EntityLists
    # @see Templates::EntityLists::ResolveNamed
    class NamedResolver < AbstractResolver
      option :ordering_identifier, Templates::Types::String.optional, optional: true

      def resolve_entities
        ordering = yield Maybe(source_entity.ordering(ordering_identifier))

        entries_scope = ordering.ordering_entries.in_default_order.currently_visible.includes(:entity).limit(limit)

        Success entries_scope.map(&:entity).compact
      end
    end
  end
end
