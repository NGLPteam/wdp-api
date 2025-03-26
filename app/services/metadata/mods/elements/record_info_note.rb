# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class RecordInfoNote < ::Metadata::MODS::Common::AbstractMapper
        attribute :content, :string
        attribute :display_label, :string
        attribute :type, :string
        attribute :type_uri, :string
        attribute :id, :string
        attribute :alt_rep_group, :string

        xml do
          root "recordInfoNote"
          namespace "http://www.loc.gov/mods/v3", "mods"

          map_content to: :content
          map_attribute "displayLabel", to: :display_label
          map_attribute "type", to: :type
          map_attribute "typeURI", to: :type_uri
          map_attribute "ID", to: :id
          map_attribute "altRepGroup", to: :alt_rep_group
        end
      end
    end
  end
end
