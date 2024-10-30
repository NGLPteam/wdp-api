# frozen_string_literal: true

module Templates
  module EntityLists
    # @see Schemas::Orderings::DynamicResolver
    # @see Templates::EntityLists::ResolveDynamic
    class DynamicResolver < AbstractResolver
      option :dynamic_ordering_definition, ::Schemas::Types.Instance(::Schemas::Orderings::Definition)

      alias entity source_entity

      alias definition dynamic_ordering_definition

      alias limit selection_limit

      alias id template_definition_id

      def resolve_entities
        call_operation("schemas.orderings.resolve_dynamic", definition:, entity:, limit:, id:)
      end
    end
  end
end
