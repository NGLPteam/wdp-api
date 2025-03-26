# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class FormatDesignation < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :name, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :version, :string

        attribute :pdf, method: :pdf?

        delegate :content, to: :name, prefix: true, allow_nil: true

        xml do
          root "formatDesignation", mixed: true

          namespace "http://www.loc.gov/premis/v3", "premis"

          map_element "formatName", to: :name
          map_element "formatVersion", to: :version
        end

        def pdf?
          name_content == "application/pdf"
        end
      end
    end
  end
end
