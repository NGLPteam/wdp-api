# frozen_string_literal: true

module Schemas
  module Mappers
    module Orderings
      # @see ::Schemas::Orderings::RenderDefinition
      class RenderMode < ::Mappers::AbstractDryType
        accepts_type! ::Schemas::Orderings::Types::RenderMode
      end
    end
  end
end
