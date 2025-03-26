# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class Storage < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :content_location, ::Metadata::PREMIS::Elements::ContentLocation

        attribute :storage_medium, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority

        xml do
          root "storage", mixed: true

          namespace "http://www.loc.gov/premis/v3", "premis"

          map_element :contentLocation, to: :content_location

          map_element :storageMedium, to: :storage_medium
        end
      end
    end
  end
end
