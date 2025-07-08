# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      module Props
        class Asset < Harvesting::Extraction::Mappings::Props::Base
          attribute :kind, :string, default: -> { "unknown" }
          attribute :mime_type, :string, default: -> { "application/octet-stream" }
          attribute :name, :string
          attribute :url, :string

          render_attr! :kind, :asset_kind
          render_attr! :mime_type, :string
          render_attr! :name, :string
          render_attr! :url, :url

          xml do
            root "asset"

            map_element "kind", to: :kind
            map_element "mime-type", to: :mime_type
            map_element "name", to: :name
            map_element "url", to: :url
          end

          validate_attr! :url do
            validates :output, presence: true, url: true
          end

          # @return [Object]
          def build_property_value_with(**subproperties)
            proxy = Harvesting::Extraction::Properties::AssetProxy.new(**subproperties, path:)
          rescue Dry::Struct::Error => e
            error = Harvesting::Extraction::Properties::Error.from(path, ?*, e)

            Dry::Monads::Failure[:properties_failed, [error]]
          else
            Dry::Monads.Success proxy
          end
        end
      end
    end
  end
end
