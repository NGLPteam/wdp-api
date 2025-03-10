# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      module Props
        class FullText < Harvesting::Extraction::Mappings::Props::Base
          attribute :kind, :string, default: -> { "markdown" }
          attribute :lang, :string, default: -> { "en" }
          attribute :content, ::Mappers::StrippedString

          render_attr! :kind, :full_text_kind
          render_attr! :lang, :string
          render_attr! :content, :string

          xml do
            root "full-text"

            map_attribute "kind", to: :kind

            map_attribute "lang", to: :lang

            map_content to: :content
          end

          def build_property_value_with(**subproperties)
            normalized = MeruAPI::Container["full_text.normalizer"].(subproperties)

            Dry::Monads.Success(normalized)
          end
        end
      end
    end
  end
end
