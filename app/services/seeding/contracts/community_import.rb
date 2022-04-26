# frozen_string_literal: true

module Seeding
  module Contracts
    # Seed a {Community}
    class CommunityImport < Base
      json do
        required(:identifier).filled(:string)
        required(:title).filled(:string)
        optional(:schema).value(:community_schema)
        optional(:collections).array(:hash, Seeding::Contracts::CollectionImport.schema)
        optional(:pages).array(:hash, Seeding::Contracts::PageImport.schema)
        optional(:properties).hash(Seeding::Contracts::DefaultCommunityProperties.schema)
        optional(:logo).maybe(:asset)
        optional(:hero_image).maybe(:asset)
        optional(:thumbnail).maybe(:asset)
      end

      rule(:collections).validate(:recursive_collections)
      rule(:pages).each(contract: Seeding::Contracts::PageImport)
      rule(:properties).validate(properties_contract: Seeding::Contracts::DefaultCommunityProperties)
    end
  end
end
