# frozen_string_literal: true

module Harvesting
  module Metadata
    # @abstract
    class XMLContext < Harvesting::Metadata::Context
      after_initialize :parse_xml!

      after_assigns :build_xml_drop!

      # @return [Nokogiri::XML::Document]
      attr_reader :doc

      delegate :xpath, :at_xpath, to: :doc

      # @return [String, nil]
      def inner_html_for(xpath)
        at_xpath(xpath)&.inner_html&.strip
      end

      private

      # @return [void]
      def build_xml_drop!
        @assigns[:xml] = build_drop Harvesting::Metadata::Drops::XMLDrop
      end

      # @return [void]
      def parse_xml!
        @doc = Nokogiri::XML(metadata_source)
      end

      def has_escaped_html?(content)
        ESCAPED_HTML_PATTERNS.any? do |pattern|
          pattern.match? content
        end
      end

      # @param [#to_s] content
      # @return [String]
      def maybe_unescape_html(content)
        MeruAPI::Container["utility.fix_possible_html"].(content.to_s).value_or(content.to_s)
      end
    end
  end
end
