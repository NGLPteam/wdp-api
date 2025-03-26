# frozen_string_literal: true

module Metadata
  module METS
    module Elements
      class Agent < ::Metadata::METS::Common::AbstractMapper
        attribute :id, ::Metadata::Shared::Xsd::Id
        attribute :role, ::Metadata::METS::Enums::Role
        attribute :otherrole, :string
        attribute :type, ::Metadata::METS::Enums::AgentType
        attribute :othertype, :string
        attribute :name, :string
        attribute :notes, ::Metadata::METS::Elements::Note, collection: true, expose_single: true

        xml do
          root "agent", mixed: true

          namespace "http://www.loc.gov/METS/"

          map_attribute "ID", to: :id
          map_attribute "ROLE", to: :role
          map_attribute "OTHERROLE", to: :otherrole
          map_attribute "TYPE", to: :type
          map_attribute "OTHERTYPE", to: :othertype

          map_element :name, to: :name
          map_element :note, to: :notes
        end
      end
    end
  end
end
