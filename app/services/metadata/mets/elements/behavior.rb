# frozen_string_literal: true

module Metadata
  module METS
    module Elements
      class Behavior < ::Metadata::METS::Common::AbstractMapper
        attribute :id, ::Metadata::Shared::Xsd::Id
        attribute :structid, ::Metadata::Shared::Xsd::IdRefs
        attribute :btype, :string
        attribute :created, :date_time
        attribute :label, :string
        attribute :groupid, :string
        attribute :admid, ::Metadata::Shared::Xsd::IdRefs

        attribute :interface_def, ::Metadata::METS::Elements::BehaviorObject, collection: true
        attribute :mechanism, ::Metadata::METS::Elements::BehaviorObject

        xml do
          root "behaviorType", mixed: true
          namespace "http://www.loc.gov/METS/"

          map_attribute "ID", to: :id
          map_attribute "STRUCTID", to: :structid
          map_attribute "BTYPE", to: :btype
          map_attribute "CREATED", to: :created
          map_attribute "LABEL", to: :label
          map_attribute "GROUPID", to: :groupid
          map_attribute "ADMID", to: :admid

          map_element :interfaceDef, to: :interface_def
          map_element :mechanism, to: :mechanism
        end
      end
    end
  end
end
