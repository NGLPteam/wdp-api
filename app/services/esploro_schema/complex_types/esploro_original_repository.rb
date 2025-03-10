# frozen_string_literal: true

module EsploroSchema
  module ComplexTypes
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#esploroOriginalRepository
    class EsploroOriginalRepository < EsploroSchema::Common::AbstractComplexType
      # Record ID in the repository in which the asset was originally stored.
      property! :asset_id, :string

      # Date record was submitted to the original Repository. The required format is YYYYMMDD
      property! :submission_date, :string

      # Name of the repository in which the asset was originally stored.
      property! :repository_name, :string

      # The format of the publication date in the original repository.
      property! :format_date, :string

      # Coverpage URL in the original repository. Used for updating usage.
      property! :cover_page_url, :string

      xml do
        root "esploroOriginalRepository", mixed: true

        map_element "assetId", to: :asset_id
        map_element "date.submission", to: :submission_date
        map_element "repositoryName", to: :repository_name
        map_element "format.date", to: :format_date
        map_element "coverpage.url", to: :cover_page_url
      end
    end
  end
end
