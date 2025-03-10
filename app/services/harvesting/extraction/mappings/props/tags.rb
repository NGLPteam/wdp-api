# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      module Props
        class Tags < Harvesting::Extraction::Mappings::Props::Base
          attribute :content, ::Mappers::StrippedString

          render_attr! :content, :tag_list, data: true do |result|
            Array(result.data["tags"])
          end

          xml do
            root "tags"

            map_content to: :content
          end

          around_render_content :capture_tags!

          private

          # @return [Dry::Monads::Success<String>]
          def build_property_value_with(content:, **)
            Dry::Monads.Success content
          end

          # @return [void]
          def capture_tags!
            render_data[:tags] = []

            yield

            render_data[:tags].compact_blank!.uniq!
          end
        end
      end
    end
  end
end
