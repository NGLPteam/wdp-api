# frozen_string_literal: true

module Templates
  module EntityLists
    # @see Templates::EntityLists::ResolveManual
    class ManualResolver < AbstractResolver
      option :manual_list_name, Templates::Types::String.optional, optional: true

      def resolve_entities
        list_name = yield Maybe(manual_list_name)

        Success source_entity.manual_list_entries.currently_visible.where(template_kind:, list_name:).limit(limit).map(&:target)
      end
    end
  end
end
