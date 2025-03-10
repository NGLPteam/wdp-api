# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      module Entities
        class Item < Harvesting::Extraction::Mappings::Entities::Abstract
          entity_kind! :item

          xml do
            root "item"
          end
        end
      end
    end
  end
end
