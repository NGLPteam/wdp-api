# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      module Entities
        class RootCollection < Harvesting::Extraction::Mappings::Entities::Abstract
          include RootEntity

          entity_kind! :collection

          attribute :enumerations, ::Harvesting::Extraction::Mappings::Entities::Enumeration, collection: true, default: -> { [] }
          attribute :collections, :harvesting_entity_collection, collection: true, default: -> { [] }
          attribute :items, :harvesting_entity_item, collection: true, default: -> { [] }

          xml do
            root "collection"

            map_element "for", to: :enumerations
            map_element "collection", to: :collections
            map_element "item", to: :items
            map_element "metadata-mapping", to: :metadata_mapping
          end
        end
      end
    end
  end
end
