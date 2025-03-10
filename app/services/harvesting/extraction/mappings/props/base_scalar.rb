# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      module Props
        # @abstract
        class BaseScalar < Harvesting::Extraction::Mappings::Props::Base
          attribute :content, ::Mappers::StrippedString

          xml do
            map_attribute "path", to: :path

            map_content to: :content
          end

          private

          # @return [Object]
          def build_property_value_with(content:, **)
            Dry::Monads.Success content
          end
        end
      end
    end
  end
end
