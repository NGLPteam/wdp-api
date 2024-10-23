# frozen_string_literal: true

module Schemas
  module Mappers
    module Orderings
      class Definition < Shale::Mapper
        attribute :id, Shale::Type::String, default: -> { "dynamic" }
        attribute :name, Shale::Type::String
        attribute :position, Shale::Type::Integer, default: -> { 1 }

        attribute :filter, Schemas::Mappers::Orderings::Filter
        attribute :handles, Schemas::Mappers::Orderings::Handles
        attribute :order, Schemas::Mappers::Orderings::Order, collection: true
        attribute :render, Schemas::Mappers::Orderings::Render, default: -> { Schemas::Mappers::Orderings::Render.new }
        attribute :select, Schemas::Mappers::Orderings::Select, default: -> { Schemas::Mappers::Orderings::Select.new }

        # @return [Schemas::Orderings::Definition]
        def to_definition
          Schemas::Orderings::Definition.new(to_hash)
        end

        xml do
          root "definition"

          map_attribute "id", to: :id
          map_attribute "name", to: :name
          map_attribute "position", to: :position

          map_element "filter", to: :filter
          map_element "handles", to: :handles
          map_element "order", to: :order
          map_element "render", to: :render
          map_element "select", to: :select
        end
      end
    end
  end
end
