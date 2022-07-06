# frozen_string_literal: true

module Harvesting
  module Assets
    class Mapping
      include Shared::EnhancedStoreModel

      attribute :entity, Harvesting::Assets::EntityMapping.to_type, default: proc { {} }
      attribute :unassociated, Harvesting::Assets::ExtractedSource.to_array_type, default: proc { [] }
      attribute :scalar, Harvesting::Assets::ScalarReference.to_array_type, default: proc { [] }
      attribute :collected, Harvesting::Assets::CollectedReference.to_array_type, default: proc { [] }

      delegate(*Harvesting::Assets::EntityMapping::IMAGE_REMOTE_URLS, to: :entity)
    end
  end
end
