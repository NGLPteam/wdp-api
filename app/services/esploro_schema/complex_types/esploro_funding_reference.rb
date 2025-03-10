# frozen_string_literal: true

module EsploroSchema
  module ComplexTypes
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#esploroFundingreference
    class EsploroFundingReference < EsploroSchema::Common::AbstractComplexType
      # For future use (not yet supported).
      property! :funder_name, :string

      # For future use (not yet supported).
      property! :isni, :string

      # For future use (not yet supported).
      property! :grid, :string

      # For future use (not yet supported).
      property! :crossref, :string

      # For future use (not yet supported).
      property! :other_identifiers, :string, collection: true

      # Grant ID. Use grant IDs from existing grants in your Esploro repository.
      property! :award_number, :string, collection: true

      # For future use (not yet supported).
      property! :award_uri, :string, collection: true

      # For future use (not yet supported).
      property! :award_title, :string, collection: true

      xml do
        root "fundingreference", mixed: true

        map_element "fundername", to: :funder_name
        map_element "funderidentifier.isni", to: :isni
        map_element "funderidentifier.grid", to: :grid
        map_element "funderidentifier.crossref", to: :crossref
        map_element "funderidentifier.other", to: :other_identifiers
        map_element "awardnumber", to: :award_number
        map_element "awarduri", to: :award_uri
        map_element "awardtitle", to: :award_title
      end
    end
  end
end
