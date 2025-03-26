# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class Signature < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :encoding, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :signer, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :signature_method, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :value, :string
        attribute :validation_rules, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :properties, :string
        attribute :key_information, ::Metadata::PREMIS::ComplexTypes::Extension

        xml do
          root "signature", mixed: true

          namespace "http://www.loc.gov/premis/v3", "premis"

          map_element :signatureEncoding, to: :encoding
          map_element :signer, to: :signer
          map_element :signatureMethod, to: :signature_method
          map_element :signatureValue, to: :value
          map_element :signatureValidationRules, to: :validation_rules
          map_element :signatureProperties, to: :properties
          map_element :keyInformation, to: :key_information
        end
      end
    end
  end
end
