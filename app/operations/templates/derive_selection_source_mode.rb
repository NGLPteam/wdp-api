# frozen_string_literal: true

module Templates
  # Determine the `selection_source_mode` for a given `selection_source`.
  class DeriveSelectionSourceMode
    include Dry::Monads[:result]

    # @param [Templates::Types::SelectionSource] selection_source
    # @return [Dry::Monads::Success(Templates::Types::SelectionSourceMode)]
    # @return [Dry::Monads::Failure(:invalid_selection_source, String)]
    def call(selection_source)
      case selection_source
      when Templates::Types::SelectionSourceAncestor
        Success "ancestor"
      when Templates::Types::SelectionSourceParent
        Success "parent"
      when Templates::Types::SelectionSourceSelf
        Success "self"
      else
        Failure[:invalid_selection_source, selection_source]
      end
    end
  end
end
