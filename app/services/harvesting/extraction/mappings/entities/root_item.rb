# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      module Entities
        class RootItem < Harvesting::Extraction::Mappings::Entities::Abstract
          include RootEntity

          entity_kind! :item

          attribute :enumerations, ::Harvesting::Extraction::Mappings::Entities::Enumeration, collection: true, default: -> { [] }
          attribute :items, :harvesting_entity_item, collection: true, default: -> { [] }

          xml do
            root "item"

            map_element "for", to: :enumerations
            map_element "item", to: :items
            map_element "metadata-mapping", to: :metadata_mapping
          end
        end
      end
    end
  end
end
