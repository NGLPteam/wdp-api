# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class Extension < ::Metadata::MODS::Common::AbstractMapper
        attribute :display_label, :string

        attribute :date_available, ::Metadata::MODS::Elements::Date
        attribute :date_accessioned, ::Metadata::MODS::Elements::Date

        attribute :has_accessioned, method: :accessioned?
        attribute :has_available, method: :available?

        xml do
          root "extension"

          namespace "http://www.loc.gov/mods/v3", "mods"

          map_attribute "displayLabel", to: :display_label

          map_element "dateAccessioned", to: :date_accessioned
          map_element "dateAvailable", to: :date_available
        end

        def accessioned?
          date_accessioned.present?
        end

        def available?
          date_available.present?
        end
      end
    end
  end
end
