# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class Rights < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :xml_id, ::Metadata::Shared::Xsd::Id
        attribute :version, ::Metadata::PREMIS::Enums::Version3

        attribute :extension, ::Metadata::PREMIS::ComplexTypes::Extension
        attribute :statement, ::Metadata::PREMIS::Elements::RightsStatement

        xml do
          root "rights", mixed: true

          namespace "http://www.loc.gov/premis/v3", "premis"

          map_attribute :xml_id, to: :xml_id
          map_attribute :version, to: :version

          map_element "rightsExtension", to: :extension
          map_element "rightsStatement", to: :statement
        end
      end
    end
  end
end
