# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class Inhibitors < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :type, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :target, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :key, :string

        xml do
          root "inhibitorsComplexType", mixed: true
          namespace "http://www.loc.gov/premis/v3", "premis"

          map_element :inhibitorType, to: :type
          map_element :inhibitorTarget, to: :target
          map_element :inhibitorKey, to: :key
        end
      end
    end
  end
end
