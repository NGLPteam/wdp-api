# frozen_string_literal: true

module EsploroSchema
  module Wrappers
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#relations
    class Relations < EsploroSchema::Common::AbstractWrapper
      # Asset to asset relationship.
      property! :relation, EsploroSchema::ComplexTypes::EsploroRelation, collection: true

      wraps! :relation

      xml do
        root "relations", mixed: true

        map_element "relation", to: :relation
      end
    end
  end
end
