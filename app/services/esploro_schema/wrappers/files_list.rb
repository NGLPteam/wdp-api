# frozen_string_literal: true

module EsploroSchema
  module Wrappers
    # @note This doesn't have a corresponding type in the XML schema,
    #   but we need it in order to properly parse the structure since
    #   the `<filesList />` element on esploroRecord tries to map directly
    #   to `esploroFile`
    # @see EsploroSchema::ComplexTypes::EsploroFile
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#esploroFile
    class FilesList < EsploroSchema::Common::AbstractWrapper
      property! :file, EsploroSchema::ComplexTypes::EsploroFile, collection: true

      wraps! :file

      xml do
        root "filesList", mixed: true

        map_element "file", to: :file
      end
    end
  end
end
