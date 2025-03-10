# frozen_string_literal: true

module Metadata
  module OAIDC
    # @abstract
    class AbstractRoot < ::Metadata::AbstractMapper
      OAI_DC_NS = "http://www.openarchives.org/OAI/2.0/oai_dc/"

      DC_NS = "http://purl.org/dc/elements/1.1/"

      ALWAYS_ARRAY = -> { [] }

      defines :elements, type: Metadata::Types::Array.of(Metadata::Types::Symbol)

      elements EMPTY_ARRAY

      class << self
        def dc_element!(name)
          element_klass = "metadata/oaidc/elements/#{name}".camelize(:upper).constantize

          attribute name, element_klass, collection: true, default: ALWAYS_ARRAY

          new_elements = elements | [name]

          elements new_elements.freeze
        end
      end
    end
  end
end
