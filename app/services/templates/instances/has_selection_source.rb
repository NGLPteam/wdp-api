# frozen_string_literal: true

module Templates
  module Instances
    # An interface for {TemplateInstance}s that have a `selection_source`.
    #
    # @see Templates::Instances::ResolveSelectionSource
    # @see Templates::Instances::SelectionSourceResolver
    # @see Templates::Definitions::HasSelectionSource#resolve_selection_source_for
    module HasSelectionSource
      extend ActiveSupport::Concern
      extend DefinesMonadicOperation

      # @param [HierarchicalEntity] entity
      # @see Templates::Definitions::ResolveSelectionSource
      # @see Templates::Definitions::SelectionSourceResolver
      # @return [Dry::Monads::Success(HierarchicalEntity)]
      # @return [Dry::Monads::Failure(:no_selection_source)]
      monadic_operation! def resolve_selection_source
        template_definition.resolve_selection_source_for(entity)
      end
    end
  end
end
