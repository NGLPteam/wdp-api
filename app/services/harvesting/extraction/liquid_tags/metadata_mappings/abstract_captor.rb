# frozen_string_literal: true

module Harvesting
  module Extraction
    module LiquidTags
      module MetadataMappings
        # @abstract
        class AbstractCaptor < Harvesting::Extraction::LiquidTags::AbstractTag
          include Dry::Effects.State(:metadata_mappings)

          args! :value

          defines :field_name, type: Harvesting::Extraction::Types::Coercible::Symbol

          field_name :some_field

          # @param [Liquid::Context] context
          # @return [void]
          def render(context)
            check!

            value = parse_value_from(context)

            unless value.blank? || value.in?(metadata_mappings[self.class.field_name])
              metadata_mappings[self.class.field_name] << value
            end

            return ""
          end

          private

          # @return [void]
          def check!
            raise Liquid::ContextError, "must be within a `<metadata-mapping/>` tag" unless metadata_mappings_available?
          end

          def metadata_mappings_available?
            metadata_mappings { false }.present?
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
