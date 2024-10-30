# frozen_string_literal: true

module Templates
  module EntityLists
    # @see Templates::EntityLists::ResolveNamed
    class NamedResolver < AbstractResolver
      option :ordering_identifier, Templates::Types::String.optional, optional: true

      def resolve_entities
        ordering = yield Maybe(source_entity.ordering(ordering_identifier))

        Success ordering.ordering_entries.limit(selection_limit).to_a
      end
    end
  end
end
