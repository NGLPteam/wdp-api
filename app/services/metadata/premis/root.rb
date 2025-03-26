# frozen_string_literal: true

module Metadata
  module PREMIS
    class Root < ::Metadata::PREMIS::Common::AbstractMapper
      attribute :version, ::Metadata::PREMIS::Enums::Version3

      attribute :objects, ::Metadata::PREMIS::Elements::Object, collection: true, expose_single: true
      attribute :events, ::Metadata::PREMIS::Elements::Event, collection: true, expose_single: true
      attribute :agents, ::Metadata::PREMIS::Elements::Agent, collection: true, expose_single: true
      attribute :rights, ::Metadata::PREMIS::Elements::Rights, collection: true, expose_single: true

      xml do
        root "premis", mixed: true

        namespace "http://www.loc.gov/premis/v3", "premis"

        map_attribute :version, to: :version

        map_element :object, to: :objects
        map_element :event, to: :events
        map_element :agent, to: :agents
        map_element :rights, to: :rights
      end
    end
  end
end
