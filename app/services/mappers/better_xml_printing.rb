# frozen_string_literal: true

module Mappers
  # @see Utility::PrettifyXML
  # @see Utility::XMLPrettifier
  module BetterXMLPrinting
    extend ActiveSupport::Concern

    def to_xml(...)
      return super unless to_pretty_xml?(...)

      MeruAPI::Container["utility.prettify_xml"].(super)
    end

    private

    def to_pretty_xml?(*, pretty: false, **)
      pretty
    end
  end
end
