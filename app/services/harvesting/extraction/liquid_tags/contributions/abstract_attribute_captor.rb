# frozen_string_literal: true

module Harvesting
  module Extraction
    module LiquidTags
      module Contributions
        # @abstract
        class AbstractAttributeCaptor < Harvesting::Extraction::LiquidTags::AbstractTag
          include Dry::Effects.State(:contribution)

          args! :value

          defines :attr_name, type: Harvesting::Extraction::Types::Coercible::Symbol

          attr_name :some_value

          # @param [Liquid::Context] context
          # @return [void]
          def render(context)
            check!

            assign_value!(context)

            return ""
          end

          private

          # @param [Liquid::Context] context
          # @return [void]
          def assign_value!(context)
            contribution[self.class.attr_name] = parse_value_from(context)
          end

          # @return [void]
          def check!
            raise Liquid::ContextError, "must be rendered within a `contribution` tag" unless contribution_available?
          end

          def contribution_available?
            contribution { false }.present?
          end

          # @param [Liquid::Context] context
          # @return [Object]
          def parse_value_from(context)
            value = args.evaluate(:value, context, allow_blank: true)

            value.kind_of?(::Liquid::Drop) ? value.to_s : value
          end
        end
      end
    end
  end
end
