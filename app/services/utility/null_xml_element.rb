# frozen_string_literal: true

module Utility
  # @!parse [ruby]
  #   # A null XML Element
  #   class NullXMLElement < Naught
  #   end
  NullXMLElement = Naught.build do |config|
    include NullXMLElementInterface

    config.mimic Nokogiri::XML::Element

    config.predicates_return false
  end
end
