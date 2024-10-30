# frozen_string_literal: true

module Templates
  module Definitions
    # @see Templates::Instances::HasOrderingPair
    module HasOrderingPair
      extend ActiveSupport::Concern
      extend DefinesMonadicOperation

      include Templates::Definitions::HasSelectionSource

      included do
        pg_enum! :ordering_source_mode, as: :selection_source_mode, allow_blank: false, suffix: :ordering_source_mode, default: "parent"

        validates :ordering_source, selection_source: true

        before_validation :maintain_ordering_source_ancestor_name!
        before_validation :maintain_ordering_source_mode!
      end

      # @param [HierarchicalEntity] entity
      # @see Templates::Definitions::ResolveSelectionSource
      # @see Templates::Definitions::SelectionSourceResolver
      # @return [Dry::Monads::Success(HierarchicalEntity)]
      # @return [Dry::Monads::Failure(:no_selection_source)]
      monadic_operation! def resolve_ordering_source_for(entity)
        call_operation("templates.definitions.resolve_selection_source", self, entity, base_attr: :ordering_source)
      end

      # @return [String, nil]
      def derive_ordering_source_ancestor_name
        case ordering_source
        when Templates::Types::SELECTION_SOURCE_ANCESTOR_PATTERN
          Regexp.last_match[:ancestor_name]
        end
      end

      # @return [Templates::Types::SelectionSourceMode]
      def derive_ordering_source_mode
        call_operation("templates.derive_selection_source_mode", ordering_source).value_or("parent")
      end

      # @return [void]
      def maintain_ordering_source_ancestor_name!
        self.ordering_source_ancestor_name = derive_ordering_source_ancestor_name
      end

      # @return [void]
      def maintain_ordering_source_mode!
        self.ordering_source_mode = derive_ordering_source_mode
      end
    end
  end
end
