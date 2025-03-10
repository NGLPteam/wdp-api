# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      module Entities
        class Collection < Harvesting::Extraction::Mappings::Entities::Abstract
          entity_kind! :collection

          attribute :collections, self, collection: true, default: -> { [] }
          attribute :items, Harvesting::Extraction::Mappings::Entities::Item, collection: true, default: -> { [] }

          xml do
            root "collection"

            map_element "collection", to: :collections
            map_element "item", to: :items
          end
        end
      end
    end
  end
end
