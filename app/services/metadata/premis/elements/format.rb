# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class Format < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :note, :string
        attribute :designation, ::Metadata::PREMIS::Elements::FormatDesignation
        attribute :registry, ::Metadata::PREMIS::Elements::FormatRegistry

        attribute :pdf, method: :pdf?

        delegate :pdf?, to: :designation, prefix: true, allow_nil: true

        xml do
          root "format", mixed: true

          namespace "http://www.loc.gov/premis/v3", "premis"

          map_element "formatNote", to: :note
          map_element "formatDesignation", to: :designation
          map_element "formatRegistry", to: :registry
        end

        def pdf?
          designation_pdf?
        end
      end
    end
  end
end
