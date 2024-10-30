# frozen_string_literal: true

module Templates
  module Definitions
    # An interface for {TemplateDefinition}s that have a `selection_source`.
    module HasSelectionSource
      extend ActiveSupport::Concern
      extend DefinesMonadicOperation

      included do
        pg_enum! :selection_source_mode, as: :selection_source_mode, allow_blank: false, suffix: :selection_source_mode, default: "self"

        validates :selection_source, selection_source: true

        before_validation :maintain_selection_source_ancestor_name!
        before_validation :maintain_selection_source_mode!
      end

      # @param [HierarchicalEntity] entity
      # @see Templates::Definitions::ResolveSelectionSource
      # @see Templates::Definitions::SelectionSourceResolver
      # @return [Dry::Monads::Success(HierarchicalEntity)]
      # @return [Dry::Monads::Failure(:no_selection_source)]
      monadic_operation! def resolve_selection_source_for(entity)
        call_operation("templates.definitions.resolve_selection_source", self, entity)
      end

      # @return [String, nil]
      def derive_selection_source_ancestor_name
        case selection_source
        when Templates::Types::SELECTION_SOURCE_ANCESTOR_PATTERN
          Regexp.last_match[:ancestor_name]
        end
      end

      # @return [Templates::Types::SelectionSourceMode]
      def derive_selection_source_mode
        call_operation("templates.derive_selection_source_mode", selection_source).value_or("self")
      end

      # @return [void]
      def maintain_selection_source_ancestor_name!
        self.selection_source_ancestor_name = derive_selection_source_ancestor_name
      end

      # @return [void]
      def maintain_selection_source_mode!
        self.selection_source_mode = derive_selection_source_mode
      end
    end
  end
end
