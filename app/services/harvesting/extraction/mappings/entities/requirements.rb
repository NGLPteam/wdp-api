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

          def met?(render_context)
            return true if expressions.blank?

            met = true

            expressions.each do |expr|
              met = false unless expr.check!(render_context)
            end

            return met
          end
        end
      end
    end
  end
end
