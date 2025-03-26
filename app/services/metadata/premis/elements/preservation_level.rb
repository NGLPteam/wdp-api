# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class PreservationLevel < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :preservation_level_type, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :preservation_level_value, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :preservation_level_role, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :preservation_level_rationale, :string
        attribute :preservation_level_date_assigned, ::Metadata::PREMIS::SimpleTypes::Edtf

        attribute :role, method: :preservation_level_role
        attribute :type, method: :preservation_level_type
        attribute :value, method: :preservation_level_value

        xml do
          root "preservationLevel", mixed: true

          namespace "http://www.loc.gov/premis/v3", "premis"

          map_element :preservationLevelType, to: :preservation_level_type
          map_element :preservationLevelValue, to: :preservation_level_value
          map_element :preservationLevelRole, to: :preservation_level_role
          map_element :preservationLevelRationale, to: :preservation_level_rationale
          map_element :preservationLevelDateAssigned, to: :preservation_level_date_assigned
        end
      end
    end
  end
end
