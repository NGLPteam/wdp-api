# frozen_string_literal: true

module Utility
  module NullXMLElementInterface
    NULL_DOC = Nokogiri::XML(<<~XML)
    <?xml version="1.0" ?>
    <null />
    XML

    def initialize(document: NULL_DOC)
      @document = document
    end

    def empty?
      true
    end

    attr_reader :document

    def at_xpath(*)
      dup
    end

    alias at_css at_xpath

    # @return [Nokogiri::XML::NodeSet]
    def xpath(*)
      Nokogiri::XML::NodeSet.new(document, [])
    end

    alias > xpath
    alias css xpath

    def text
      ""
    end
  end
end
