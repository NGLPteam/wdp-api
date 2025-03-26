# frozen_string_literal: true

module Metadata
  module OAIDC
    # The root element for an OAI DC Metadata document.
    class Root < Metadata::OAIDC::AbstractRoot
      dc_element! :title
      dc_element! :creator
      dc_element! :subject
      dc_element! :description
      dc_element! :publisher
      dc_element! :contributor
      dc_element! :date
      dc_element! :type
      dc_element! :format
      dc_element! :identifier
      dc_element! :source
      dc_element! :language
      dc_element! :relation
      dc_element! :coverage
      dc_element! :rights

      xml do
        root "dc", mixed: true, ordered: true

        namespace OAI_DC_NS, "oai_dc"

        map_element "title", to: :title, namespace: DC_NS, prefix: "dc"
        map_element "creator", to: :creator, namespace: DC_NS, prefix: "dc"
        map_element "subject", to: :subject, namespace: DC_NS, prefix: "dc"
        map_element "description", to: :description, namespace: DC_NS, prefix: "dc"
        map_element "publisher", to: :publisher, namespace: DC_NS, prefix: "dc"
        map_element "contributor", to: :contributor, namespace: DC_NS, prefix: "dc"
        map_element "date", to: :date, namespace: DC_NS, prefix: "dc"
        map_element "type", to: :type, namespace: DC_NS, prefix: "dc"
        map_element "format", to: :format, namespace: DC_NS, prefix: "dc"
        map_element "identifier", to: :identifier, namespace: DC_NS, prefix: "dc"
        map_element "source", to: :source, namespace: DC_NS, prefix: "dc"
        map_element "language", to: :language, namespace: DC_NS, prefix: "dc"
        map_element "relation", to: :relation, namespace: DC_NS, prefix: "dc"
        map_element "coverage", to: :coverage, namespace: DC_NS, prefix: "dc"
        map_element "rights", to: :rights, namespace: DC_NS, prefix: "dc"
      end
    end
  end
end
