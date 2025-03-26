# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class EventDetailInformation < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :event_detail, :string
        attribute :extension, ::Metadata::PREMIS::ComplexTypes::Extension

        xml do
          root "eventDetailInformation", mixed: true

          namespace "http://www.loc.gov/premis/v3", "premis"

          map_element :eventDetail, to: :event_detail
          map_element :eventDetailExtension, to: :extension
        end
      end
    end
  end
end
