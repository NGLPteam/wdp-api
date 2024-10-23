# frozen_string_literal: true

module Schemas
  module Mappers
    module Orderings
      # @see ::Schemas::Orderings::Definition#handles
      # @see ::Schemas::Associations::HandledSchema
      class Handles < Shale::Mapper
        attribute :namespace, Shale::Type::String
        attribute :identifier, Shale::Type::String

        # @return [::Schemas::Associations::HandledSchema]
        def to_handles
          ::Schemas::Associations::HandledSchema
        end

        hsh do
          map :namespace, to: :namespace
          map :identifier, to: :identifier
        end

        json do
          map "namespace", to: :namespace
          map "identifier", to: :identifier
        end

        xml do
          root "handles"

          map_attribute "namespace", to: :namespace
          map_attribute "identifier", to: :identifier
        end
      end
    end
  end
end
