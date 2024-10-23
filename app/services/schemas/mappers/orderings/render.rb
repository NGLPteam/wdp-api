# frozen_string_literal: true

module Schemas
  module Mappers
    module Orderings
      # @see ::Schemas::Orderings::RenderDefinition
      class Render < Shale::Mapper
        attribute :mode, ::Schemas::Mappers::Orderings::RenderMode, default: -> { "flat" }

        xml do
          root "render"

          map_attribute "mode", to: :mode
        end
      end
    end
  end
end
