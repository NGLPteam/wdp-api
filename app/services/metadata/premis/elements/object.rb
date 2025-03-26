# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class Object < ::Metadata::PREMIS::Common::AbstractMapper
        FILE_PATTERN = /\Afile\z/i

        attribute :xml_id, ::Metadata::Shared::Xsd::Id

        attribute :version, ::Metadata::PREMIS::Enums::Version3

        attribute :type, :string

        attribute :environment_extension, ::Metadata::PREMIS::ComplexTypes::Extension

        attribute :environment_function, ::Metadata::PREMIS::Elements::EnvironmentFunction

        attribute :environment_designation, ::Metadata::PREMIS::Elements::EnvironmentDesignation

        attribute :environment_registry, ::Metadata::PREMIS::Elements::EnvironmentRegistry

        attribute :linking_event_identifier, ::Metadata::PREMIS::Elements::LinkingEventIdentifier

        attribute :linking_rights_statement_identifier, ::Metadata::PREMIS::Elements::LinkingRightsStatementIdentifier

        attribute :object_category, :string

        attribute :object_characteristics, ::Metadata::PREMIS::Elements::ObjectCharacteristics

        attribute :object_identifier, ::Metadata::PREMIS::Elements::ObjectIdentifier

        attribute :original_name, ::Metadata::PREMIS::Elements::OriginalName

        attribute :preservation_level, ::Metadata::PREMIS::Elements::PreservationLevel

        attribute :relationship, ::Metadata::PREMIS::Elements::Relationship

        attribute :signature_information, ::Metadata::PREMIS::Elements::SignatureInformation

        attribute :significant_properties, ::Metadata::PREMIS::Elements::SignificantProperties, collection: true

        attribute :storage, ::Metadata::PREMIS::Elements::Storage

        attribute :category, method: :object_category

        attribute :identifier, method: :object_identifier

        attribute :file, method: :file?

        attribute :pdf, method: :pdf?

        delegate :pdf?, to: :object_characteristics, prefix: :oc, allow_nil: true

        xml do
          root "object", mixed: true

          namespace "http://www.loc.gov/premis/v3", "premis"

          map_attribute "xml_id", to: :xml_id
          map_attribute "version", to: :version
          map_attribute "type", to: :type, namespace: "http://www.w3.org/2001/XMLSchema-instance", prefix: "xsi"

          map_element "environmentExtension", to: :environment_extension

          map_element "environmentFunction", to: :environment_function

          map_element "environmentDesignation", to: :environment_designation

          map_element "environmentRegistry", to: :environment_registry

          map_element "linkingEventIdentifier", to: :linking_event_identifier

          map_element "linkingRightsStatementIdentifier", to: :linking_rights_statement_identifier

          map_element "objectCategory", to: :object_category

          map_element "objectCharacteristics", to: :object_characteristics

          map_element "objectIdentifier", to: :object_identifier

          map_element "originalName", to: :original_name

          map_element "preservationLevel", to: :preservation_level

          map_element "relationship", to: :relationship

          map_element "signatureInformation", to: :signature_information

          map_element "significantProperties", to: :significant_properties

          map_element "storage", to: :storage
        end

        def file?
          FILE_PATTERN.match?(type) || FILE_PATTERN.match?(object_category)
        end

        def pdf?
          oc_pdf?
        end
      end
    end
  end
end
