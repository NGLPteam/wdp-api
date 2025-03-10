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
    end
  end
end
