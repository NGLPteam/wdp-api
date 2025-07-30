# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      module Entities
        class Item < Harvesting::Extraction::Mappings::Entities::Abstract
          ::Shale::Type.register(:harvesting_entity_item, self)

          # This must be present in order to deal with nested items/collections & enumerations.
          require_relative "./collection"

          attribute :enumerations, ::Harvesting::Extraction::Mappings::Entities::Enumeration, collection: true, default: -> { [] }
          attribute :items, self, collection: true, default: -> { [] }

          entity_kind! :item

          xml do
            root "item"

            map_element "for", to: :enumerations
            map_element "item", to: :items
          end
        end
      end
    end
  end
end
