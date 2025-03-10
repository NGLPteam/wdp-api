# frozen_string_literal: true

module EsploroSchema
  module ComplexTypes
    # @note Despite the way the XSD is structured, we nest this under {EsploroSchema::Wrappers::FilesList}
    #   so that the structure of the document is preserved and it behaves like other similar collections,
    #   e.g. creators and contributors.
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#esploroFile
    class EsploroFile < EsploroSchema::Common::AbstractComplexType
      property! :name, :string
      property! :type, :string
      property! :description, :string
      property! :title, :string
      property! :rights, :string
      property! :license_code, :string
      property! :size, :string
      property! :extension, :string
      property! :persistent_url, :string
      property! :download_url, :string
      property! :order, :string

      xml do
        root "file", mixed: true

        map_element "file.name", to: :name
        map_element "file.type", to: :type
        map_element "file.description", to: :description
        map_element "file.title", to: :title
        map_element "file.rights", to: :rights
        map_element "file.license.code", to: :license_code
        map_element "file.size", to: :size
        map_element "file.extension", to: :extension
        map_element "file.persistent.url", to: :persistent_url
        map_element "file.download.url", to: :download_url
        map_element "file.order", to: :order
      end
    end
  end
end
