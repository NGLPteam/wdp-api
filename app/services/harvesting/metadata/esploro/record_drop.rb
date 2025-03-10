# frozen_string_literal: true

module Harvesting
  module Metadata
    module Esploro
      # A wrapper around {EsploroSchema::Record} and acts
      # as the top-level drop for esploro metadata content.
      class RecordDrop < AbstractEsploroDrop
        EsploroSchema::RecordAndDataConsolidation::RECORD_PROPERTIES.each do |prop|
          expose_property! prop
        end
      end
    end
  end
end
