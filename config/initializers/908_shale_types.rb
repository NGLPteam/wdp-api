# frozen_string_literal: true

# Register types for use in Shale in order to avoid circular references.
Rails.application.config.to_prepare do
  ::Shale::Type.register(:harvesting_entity_item, Harvesting::Extraction::Mappings::Entities::Item)

  ::Shale::Type.register(:harvesting_entity_collection, Harvesting::Extraction::Mappings::Entities::Collection)
end
