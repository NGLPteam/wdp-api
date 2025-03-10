# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      module Entities
        # Creates a tag that takes an expression and an optional reason, where the expression
        # **must** resolve to a present value or else it won't generate the entity.
        #
        # @example xml
        #   <expr reason="must have a volume">{{jats.volume}}</expr>
        class RequirementExpression < Harvesting::Extraction::Mappings::Abstract
          attribute :reason, :string
          attribute :expression, ::Mappers::StrippedString

          render_attr! :expression

          xml do
            root "expr"

            map_attribute "reason", to: :reason

            map_content to: :expression
          end

          # @param [Harvesting::Extraction::RenderContext] render_context
          # @return [String, nil]
          def value_for(render_context)
            rendered_attributes_for(render_context) => { expression:, }

            expression.value_or(nil)
          end
        end
      end
    end
  end
end
