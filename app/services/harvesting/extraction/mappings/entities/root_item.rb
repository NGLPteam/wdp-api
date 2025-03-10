# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      module Entities
        class RootItem < Harvesting::Extraction::Mappings::Entities::Abstract
          include RootEntity

          entity_kind! :item

          xml do
            root "item"

            map_element "metadata-mapping", to: :metadata_mapping
          end
        end
      end
    end
  end
end
