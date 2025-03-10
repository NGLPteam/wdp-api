# frozen_string_literal: true

module EsploroSchema
  module ComplexTypes
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#esploroPatent
    class EsploroPatent < EsploroSchema::Common::AbstractComplexType
      # Patent status. Use value from code table:
      # Application
      # Published
      property! :status, :string

      # Patent number (identifier).
      property! :number, :string

      # The abbreviated form of the patent number commonly used in documents.
      property! :abbrevnum, :string

      # The patent kind code.
      # @see https://www.wipo.int/patentscope/en/data/kind_codes.html
      property! :kind_code, :string

      # The patent application number.
      property! :application_number, :string

      # The patent application code.
      property! :applicationcode, :string

      # Agency where the patent was registered. Use value from code table.
      property! :agency, :string

      xml do
        root "esploroPatent", mixed: true

        map_element "patent.status", to: :status
        map_element "patent.number", to: :number
        map_element "patent.abbrevnum", to: :abbrevnum
        map_element "patent.kindcode", to: :kind_code
        map_element "patent.applicationnum", to: :application_number
        map_element "patent.applicationcode", to: :applicationcode
        map_element "patent.agency", to: :agency
      end
    end
  end
end
