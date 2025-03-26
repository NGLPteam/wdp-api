# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class SignatureInformation < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :signature, ::Metadata::PREMIS::Elements::Signature
        attribute :extension, ::Metadata::PREMIS::ComplexTypes::Extension

        xml do
          root "signatureInformation", mixed: true

          namespace "http://www.loc.gov/premis/v3", "premis"

          map_element :signature, to: :signature
          map_element :signatureInformationExtension, to: :extension
        end
      end
    end
  end
end
