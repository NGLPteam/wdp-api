# frozen_string_literal: true

module PilotHarvesting
  # Defines an `nglp:journal`
  class JournalDefinition < CollectionDefinition
    metadata_format "jats"

    schema_name "nglp:journal"

    def properties
      super.merge(issn:)
    end
  end
end
