# frozen_string_literal: true

module Schemas
  module Mappers
    module Orderings
      # @see ::Schemas::Orderings::SelectDefinition
      class SelectDirect < ::Mappers::AbstractDryType
        accepts_type! ::Schemas::Orderings::Types::SelectDirect
      end
    end
  end
end
