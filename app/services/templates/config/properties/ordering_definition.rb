# frozen_string_literal: true

module Templates
  module Config
    module Properties
      # A dynamic ordering definition type.
      #
      # @see Schemas::Mappers::Orderings::Definition
      class OrderingDefinition < Shale::Mapper
        attribute :id, Shale::Type::String, default: -> { "dynamic" }
        attribute :name, Shale::Type::String, default: -> { "Dynamic Template Ordering" }
        attribute :position, Shale::Type::Integer, default: -> { 1 }

        attribute :filter, ::Schemas::Mappers::Orderings::Filter
        attribute :order, ::Schemas::Mappers::Orderings::Order, collection: true
        attribute :render, ::Schemas::Mappers::Orderings::Render, default: -> { ::Schemas::Mappers::Orderings::Render.new }
        attribute :select, ::Schemas::Mappers::Orderings::Select, default: -> { ::Schemas::Mappers::Orderings::Select.new }

        xml do
          root "definition"

          map_element "filter", to: :filter
          map_element "order", to: :order
          map_element "render", to: :render
          map_element "select", to: :select
        end

        # @param [Templates::Types::Kind] template_kind
        # @return [Schemas::Orderings::Definition]
        def to_definition(template_kind:)
          Schemas::Orderings::Definition.new(to_hash).tap do |definition|
            if template_kind == "link_list"
              definition.name = "Dynamic Links"
              definition.render.mode = "flat"
              definition.select.direct = "none"
            end
          end
        end
      end
    end
  end
end
