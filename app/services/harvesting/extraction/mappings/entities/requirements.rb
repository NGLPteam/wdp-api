# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      module Entities
        class Requirements < Harvesting::Extraction::Mappings::Abstract
          attribute :expressions, Harvesting::Extraction::Mappings::Entities::RequirementExpression, collection: true, default: proc { [] }

          xml do
            root "requires"

            map_element "expr", to: :expressions
          end
        end
      end
    end
  end
end
