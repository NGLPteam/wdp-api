# frozen_string_literal: true

module Metadata
  module METS
    module Elements
      class StructMap < ::Metadata::METS::Common::AbstractMapper
        attribute :id, ::Metadata::Shared::Xsd::Id
        attribute :type, :string
        attribute :label, :string
        attribute :div, ::Metadata::METS::Elements::Div

        xml do
          root "structMap", mixed: true

          namespace "http://www.loc.gov/METS/"

          map_attribute "ID", to: :id
          map_attribute "TYPE", to: :type
          map_attribute "LABEL", to: :label

          map_element :div, to: :div
        end
      end
    end
  end
end
