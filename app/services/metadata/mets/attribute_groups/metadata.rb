# frozen_string_literal: true

module Metadata
  module METS
    module AttributeGroups
      module Metadata
        extend ActiveSupport::Concern

        included do
          attribute :mdtype, ::Metadata::METS::Enums::MetadataType
          attribute :mdtypeversion, :string
          attribute :othermdtype, :string

          xml do
            map_attribute "MDTYPE", to: :mdtype
            map_attribute "MDTYPEVERSION", to: :mdtypeversion
            map_attribute "OTHERMDTYPE", to: :othermdtype
          end
        end
      end
    end
  end
end
