# frozen_string_literal: true

module Seeding
  module Contracts
    # Seed a {Collection}
    class CollectionImport < Base
      json do
        required(:identifier).filled(:string)
        required(:title).filled(:string)
        optional(:subtitle).maybe(:string)
        required(:schema).filled(:collection_schema)

        optional(:doi).maybe(:string)
        optional(:issn).maybe(:string)

        optional(:collections).array(:hash, type_schema)

        optional(:pages).array(:hash, Seeding::Contracts::PageImport.schema)
        optional(:properties).maybe(:hash)

        optional(:hero_image).maybe(:asset)
        optional(:thumbnail).maybe(:asset)

        # optional(:journal_properties).maybe(:hash, Seeding::Contracts::JournalProperties.schema)
        # optional(:series_properties).maybe(:hash, Seeding::Contracts::SeriesProperties.schema)
        # optional(:unit_properties).maybe(:hash, Seeding::Contracts::UnitProperties.schema)
      end

      rule(:collections).validate(:recursive_collections)
      rule(:pages).each(contract: Seeding::Contracts::PageImport)

      # rule(:journal_properties).validate(properties_contract: Seeding::Contracts::JournalProperties)
      # rule(:series_properties).validate(properties_contract: Seeding::Contracts::SeriesProperties)
      # rule(:unit_properties).validate(properties_contract: Seeding::Contracts::UnitProperties)
    end
  end
end
