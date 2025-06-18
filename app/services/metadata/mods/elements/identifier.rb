# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class Identifier < ::Metadata::MODS::Common::AbstractMapper
        HANDLE_URI = %r,\Ahttps?://hdl.handle.net/.+,i

        attribute :content, :string
        attribute :display_label, :string
        attribute :type, :string
        attribute :type_uri, :string
        attribute :invalid, :string
        attribute :alt_rep_group, :string

        attribute :is_handle, method: :derive_is_handle

        xml do
          root "nameIdentifier"
          namespace "http://www.loc.gov/mods/v3", "mods"

          map_content to: :content
          map_attribute "displayLabel", to: :display_label
          map_attribute "type", to: :type
          map_attribute "typeURI", to: :type_uri
          map_attribute "invalid", to: :invalid
          map_attribute "altRepGroup", to: :alt_rep_group
        end

        # @api private
        def derive_is_handle
          type == "uri" && HANDLE_URI.match?(content)
        end
      end
    end
  end
end
