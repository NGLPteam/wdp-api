# frozen_string_literal: true

module Metadata
  module METS
    class Root < ::Metadata::METS::Common::AbstractMapper
      include Metadata::METS::Common::EnumeratesFiles

      attribute :id, ::Metadata::Shared::Xsd::Id
      attribute :objid, :string
      attribute :label, :string
      attribute :type, :string
      attribute :profile, :string

      attribute :headers, ::Metadata::METS::Elements::Header, collection: true, expose_single: true

      # Administrative metadata sections.
      attribute :admin_sections, ::Metadata::METS::Elements::AdministrativeMetadataSection, collection: true, expose_single: true

      # Descriptive metadata sections.
      attribute :descriptive_sections, ::Metadata::METS::Elements::MetadataSection, collection: true, expose_single: true

      attribute :file_sections, ::Metadata::METS::Elements::FileSection, collection: true, expose_single: true

      attribute :struct_maps, ::Metadata::METS::Elements::StructMap, collection: true, expose_single: true

      attribute :struct_links, ::Metadata::METS::Elements::StructLink, collection: true, expose_single: true

      attribute :behavior_sections, ::Metadata::METS::Elements::BehaviorSection, collection: true

      attribute :amd_sec, method: :admin_sections

      attribute :dmd_sec, method: :descriptive_sections

      xml do
        root "mets", mixed: true

        namespace "http://www.loc.gov/METS/"

        map_attribute "ID", to: :id
        map_attribute "OBJID", to: :objid
        map_attribute "LABEL", to: :label
        map_attribute "TYPE", to: :type
        map_attribute "PROFILE", to: :profile

        map_element :metsHdr, to: :headers
        map_element :dmdSec, to: :descriptive_sections
        map_element :amdSec, to: :admin_sections
        map_element :fileSec, to: :file_sections
        map_element :structMap, to: :struct_maps
        map_element :structLink, to: :struct_links
        map_element :behaviorSec, to: :behavior_sections
      end

      def each_file
        return enum_for(__method__) unless block_given?

        Array(file_sections).each do |section|
          section.each_file do |file|
            yield file
          end
        end
      end

      # @return [::Metadata::METS::Elements::Header, nil]
      def first_header
        headers.first
      end
    end
  end
end
