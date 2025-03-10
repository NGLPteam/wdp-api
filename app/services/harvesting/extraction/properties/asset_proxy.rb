# frozen_string_literal: true

module Harvesting
  module Extraction
    module Properties
      # A proxy for an asset that can be a scalar property or be collected elsewhere.
      class AssetProxy < Support::FlexibleStruct
        attribute :path, Harvesting::Extraction::Types::Coercible::String

        attribute :url, Harvesting::Metadata::Types::URL

        attribute? :name, Harvesting::Extraction::Types::String.optional
        attribute? :kind, Harvesting::Extraction::Types::String.optional
        attribute? :mime_type, ::AppTypes::MIME.optional

        alias full_path path

        # @return [String]
        def identifier
          @identifier ||= [path, name].compact_blank.join(?-)
        end

        def props
          {
            name:,
            mime_type:,
          }
        end
      end
    end
  end
end
