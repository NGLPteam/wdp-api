# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class NamePart < ::Metadata::MODS::Common::AbstractMapper
        include Dry::Core::Memoizable

        attribute :content, :string
        attribute :type, :string

        attribute :given_name, method: :given_name
        attribute :family_name, method: :family_name
        attribute :parsed, method: :parsed_successfully?

        xml do
          root "namePart"
          namespace "http://www.loc.gov/mods/v3", "mods"

          map_content to: :content
          map_attribute "type", to: :type
        end

        def blank_for_liquid?
          !parsed
        end

        def family_name
          parsed_name.try(:family)
        end

        def given_name
          parsed_name.try(:given)
        end

        def parsed_successfully?
          parsed_name.present? && parsed_name.given.present? && parsed_name.family.present?
        end

        private

        memoize def parsed_name
          MeruAPI::Container["utility.parse_name"].(content).value_or(nil)
        end
      end
    end
  end
end
