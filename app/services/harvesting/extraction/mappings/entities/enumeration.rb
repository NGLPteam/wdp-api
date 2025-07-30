# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      module Entities
        # An enumeration of entities that can extract an array value from
        # a given Liquid expression, enumerate that value in Ruby, and expose
        # each element in Liquid assigns below.
        class Enumeration < Harvesting::Extraction::Mappings::Abstract
          attribute :element, :string, default: -> { "elt" }
          attribute :expression, :string
          attribute :enumerations, self, collection: true, default: -> { [] }
          attribute :collections, :harvesting_entity_collection, collection: true, default: -> { [] }
          attribute :items, :harvesting_entity_item, collection: true, default: -> { [] }

          xml do
            root "for"

            map_attribute "each", to: :element
            map_attribute "of", to: :expression

            map_element "for", to: :enumerations
            map_element "collection", to: :collections
            map_element "item", to: :items
          end

          # @param [Harvesting::Extraction::RenderContext] render_context
          # @param [Harvesting::Entities::Struct, nil] parent
          # @return [<Harvesting::Entities::Struct>]
          def render_structs_for(render_context, parent: nil)
            return EMPTY_ARRAY unless valid_to_enumerate?(render_context, parent:)

            [].tap do |structs|
              render_context.with_enumerated_assignment(element:, expression:) do
                structs.concat(enumerations.flat_map { _1.render_structs_for(render_context, parent:) })
                structs.concat(collections.map { _1.render_struct_for(render_context, parent:) })
                structs.concat(items.map { _1.render_struct_for(render_context, parent:) })
              end
            end
          end

          private

          # @see Harvesting::Extraction::Enumerations::Validator#check!
          # @param [Harvesting::Extraction::RenderContext] render_context
          # @param [Harvesting::Entities::Struct, nil] parent
          def valid_to_enumerate?(render_context, parent:)
            Harvesting::Extraction::Enumerations::Validator.check!(element:, expression:, parent:, render_context:)
          end
        end
      end
    end
  end
end
