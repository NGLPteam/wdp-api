# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class EventOutcomeDetail < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :note, :string
        attribute :extension, ::Metadata::PREMIS::ComplexTypes::Extension

        xml do
          root "eventOutcomeDetail", mixed: true

          namespace "http://www.loc.gov/premis/v3", "premis"

          map_element :eventOutcomeDetailNote, to: :note
          map_element :eventOutcomeDetailExtension, to: :extension
        end
      end
    end
  end
end
