# frozen_string_literal: true

module Metadata
  module METS
    module Elements
      class SmArcLink < ::Metadata::METS::Common::AbstractMapper
        attribute :id, ::Metadata::Shared::Xsd::Id
        attribute :arctype, :string
        attribute :admid, ::Metadata::Shared::Xsd::IdRefs

        xml do
          root "smArcLink", mixed: true
          namespace "http://www.loc.gov/METS/"

          map_attribute "ID", to: :id
          map_attribute "ARCTYPE", to: :arctype
          map_attribute "ADMID", to: :admid
        end
      end
    end
  end
end
