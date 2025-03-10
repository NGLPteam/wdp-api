# frozen_string_literal: true

module Harvesting
  module Extraction
    module LiquidTags
      module Contributors
        # @abstract
        class AbstractAttributeCaptor < Harvesting::Extraction::LiquidTags::AbstractTag
          include Dry::Effects.State(:contributor)
          include Dry::Effects.State(:tracked_attributes)
          include Dry::Effects.State(:tracked_properties)

          args! :value

          defines :attr_name, type: Harvesting::Extraction::Types::Coercible::Symbol
          defines :trackable, type: Harvesting::Extraction::Types::Bool

          attr_name :some_value

          trackable true

          # @param [Liquid::Context] context
          # @return [void]
          def render(context)
            check!

            assign_value!(context)

            track! if trackable?

            return ""
          end

          private

          # @param [Liquid::Context] context
          # @return [void]
          def assign_value!(context)
            contributor[self.class.attr_name] = parse_value_from(context)
          end

          # @return [void]
          def check!
            raise Liquid::ContextError, "must be rendered within a `person` or `organization` contributor tag" unless contributor_available?
          end

          def contributor_available?
            contributor { false }.present?
          end

          # @param [Liquid::Context] context
          # @return [Object]
          def parse_value_from(context)
            value = args.evaluate(:value, context, allow_blank: true)

            value.kind_of?(::Liquid::Drop) ? value.to_s : value
          end

          # @return [void]
          def track!
            tracked_attributes << self.class.attr_name
          end

          def trackable?
            self.class.trackable
          end
        end
      end
    end
  end
end
