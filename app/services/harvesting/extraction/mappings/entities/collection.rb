# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      module Entities
        class Collection < Harvesting::Extraction::Mappings::Entities::Abstract
          ::Shale::Type.register(:harvesting_entity_collection, self)

          entity_kind! :collection

          attribute :enumerations, ::Harvesting::Extraction::Mappings::Entities::Enumeration, collection: true, default: -> { [] }
          attribute :collections, self, collection: true, default: -> { [] }
          attribute :items, :harvesting_entity_item, collection: true, default: -> { [] }

          xml do
            root "collection"

            map_element "for", to: :enumerations
            map_element "collection", to: :collections
            map_element "item", to: :items
          end
        end
      end
    end
  end
end
