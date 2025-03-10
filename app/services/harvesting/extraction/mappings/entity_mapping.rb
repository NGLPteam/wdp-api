# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      class EntityMapping < Harvesting::Extraction::Mappings::Abstract
        attribute :collections, Harvesting::Extraction::Mappings::Entities::RootCollection, collection: true, default: -> { [] }
        attribute :items, Harvesting::Extraction::Mappings::Entities::RootItem, collection: true, default: -> { [] }

        xml do
          root "entities"

          map_element "collection", to: :collections
          map_element "item", to: :items
        end

        def empty?
          collections.blank? && items.blank?
        end

        # @param [Harvesting::Extraction::RenderContext] render_context
        # @return [<Harvesting::Entities::Struct>]
        def render_structs_for(render_context)
          [].tap do |structs|
            structs.concat(collections.map { _1.render_struct_for(render_context) })
            structs.concat(items.map { _1.render_struct_for(render_context) })
          end
        end

        # @return [<String>]
        def schema_declarations
          [*collections, *items].reduce([]) do |d, ent|
            d | ent.schema_declarations
          end
        end
      end
    end
  end
end
