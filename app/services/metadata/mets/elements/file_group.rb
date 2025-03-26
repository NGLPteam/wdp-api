# frozen_string_literal: true

module Metadata
  module METS
    module Elements
      class FileGroup < ::Metadata::METS::Common::AbstractMapper
        include Metadata::METS::Common::EnumeratesFiles

        attribute :id, ::Metadata::Shared::Xsd::Id
        attribute :versdate, :date_time
        attribute :admid, ::Metadata::Shared::Xsd::IdRefs
        attribute :use, :string
        attribute :nested_groups, self, collection: true
        attribute :top_level_files, ::Metadata::METS::Elements::File, collection: true

        xml do
          root "fileGrp", mixed: true

          namespace "http://www.loc.gov/METS/"

          map_attribute "ID", to: :id
          map_attribute "VERSDATE", to: :versdate
          map_attribute "ADMID", to: :admid
          map_attribute "USE", to: :use

          map_element "fileGrp", to: :nested_groups
          map_element "file", to: :top_level_files
        end

        def each_file
          return enum_for(__method__) unless block_given?

          Array(nested_groups).each do |group|
            group.each_file do |file|
              yield file
            end
          end

          Array(top_level_files).each do |f|
            yield f
          end
        end
      end
    end
  end
end
