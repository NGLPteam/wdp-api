# frozen_string_literal: true

module EsploroSchema
  module ComplexTypes
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#esploroCreator
    class EsploroCreator < EsploroSchema::ComplexTypes::EsploroAuthor
      property! :creator_name, :string

      xml do
        root "creator", mixed: true

        map_element "creatorname", to: :creator_name
      end
    end
  end
end
