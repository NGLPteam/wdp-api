# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class ContentLocation < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :simple_link, :string
        attribute :content_location_type, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :content_location_value, :string

        attribute :type, method: :content_location_type
        attribute :value, method: :content_location_value

        xml do
          root "contentLocation", mixed: true

          namespace "http://www.loc.gov/premis/v3", "premis"

          map_attribute :simple_link, to: :simple_link
          map_element "contentLocationType", to: :content_location_type
          map_element "contentLocationValue", to: :content_location_value
        end
      end
    end
  end
end
