# frozen_string_literal: true

module Metadata
  module OAIDC
    # A base mapper for all of the OAI DC core properties.
    # @abstract
    class AbstractElement < Metadata::AbstractMapper
      DC_NS = "http://purl.org/dc/elements/1.1/"

      XML_NS = "http://www.w3.org/XML/1998/namespace"

      attribute :content, :string

      attribute :lang, :string

      xml do
        namespace DC_NS, "dc"

        map_attribute "lang", to: :lang, namespace: XML_NS, prefix: "xml"

        map_content to: :content
      end
    end
  end
end
