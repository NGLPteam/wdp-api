# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class RightsGranted < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :act, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :restriction, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :term_of_grant, ::Metadata::PREMIS::ComplexTypes::StartAndEndDate
        attribute :term_of_restriction, ::Metadata::PREMIS::ComplexTypes::StartAndEndDate
        attribute :note, :string

        xml do
          root "rightsGranted", mixed: true

          namespace "http://www.loc.gov/premis/v3", "premis"

          map_element :act, to: :act
          map_element :restriction, to: :restriction
          map_element :termOfGrant, to: :term_of_grant
          map_element :termOfRestriction, to: :term_of_restriction
          map_element :rightsGrantedNote, to: :note
        end
      end
    end
  end
end
