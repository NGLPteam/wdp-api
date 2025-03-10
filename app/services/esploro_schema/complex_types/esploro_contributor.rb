# frozen_string_literal: true

module EsploroSchema
  module ComplexTypes
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#esploroContributor
    class EsploroContributor < EsploroSchema::ComplexTypes::EsploroAuthor
      property! :contributor_name, :string

      xml do
        root "contributor", mixed: true

        map_element "contributorname", to: :contributor_name
      end
    end
  end
end
