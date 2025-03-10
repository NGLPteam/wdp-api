# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      module Entities
        class RootCollection < Harvesting::Extraction::Mappings::Entities::Abstract
          include RootEntity

          entity_kind! :collection

          attribute :collections, Harvesting::Extraction::Mappings::Entities::Collection, collection: true, default: -> { [] }
          attribute :items, Harvesting::Extraction::Mappings::Entities::Item, collection: true, default: -> { [] }

          xml do
            root "collection"

            map_element "collection", to: :collections
            map_element "item", to: :items
            map_element "metadata-mapping", to: :metadata_mapping
          end
        end
      end
    end
  end
end
