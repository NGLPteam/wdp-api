# frozen_string_literal: true

module Metadata
  module MODS
    # This class does some complicated things with `Mods::Date` in order
    # to parse dates based on the `<date encoding>` attribute.
    #
    # @see https://github.com/sul-dlss/mods/blob/master/lib/mods/date.rb
    module Elements
      class Date < ::Metadata::MODS::Common::AbstractMapper
        attribute :raw_value, :string
        attribute :value, :date
        # Lutaml::Model already has a reserved encoding attribute as part of its parsing.
        attribute :date_encoding, :string
        attribute :qualifier, :string
        attribute :point, :string
        attribute :key_date, :string
        attribute :calendar, :string

        delegate :iso8601, to: :value, allow_nil: true, prefix: :date

        attribute :iso8601, method: :date_iso8601

        stringifies_drop_with! :iso8601

        xml do
          root :date, mixed: true

          namespace "http://www.loc.gov/mods/v3", "mods"

          map_content to: :value, with: { from: :parse_date_from_xml, to: :convert_date_to_xml }

          map_attribute "encoding", to: :date_encoding
          map_attribute "qualifier", to: :qualifier
          map_attribute "point", to: :point
          map_attribute "keyDate", to: :key_date
          map_attribute "calendar", to: :calendar
        end

        private

        # @param [Metadata::MODS::Date] model
        # @return [String]
        def convert_date_to_xml(model, _parent, _doc)
          model.raw_value
        end

        # @param [Metadata::MODS::Date] model
        # @param [String] raw_value
        # @return [void]
        def parse_date_from_xml(model, raw_value)
          model.raw_value = raw_value

          model.value = parse_date_with_mods(model.date_encoding, raw_value).try(:date)
        end

        def parse_date_with_mods(encoding, raw_value)
          builder = Nokogiri::XML::Builder.new do |xml|
            xml.date(raw_value, encoding:)
          end

          xml = Nokogiri::XML(builder.to_xml)

          ::Mods::Date.from_element(xml)
        end
      end
    end
  end
end
