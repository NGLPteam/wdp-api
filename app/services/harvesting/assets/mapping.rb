# frozen_string_literal: true

module Harvesting
  module Assets
    class Mapping
      include StoreModel::Model

      attribute :unassociated, Harvesting::Assets::ExtractedSource.to_array_type, default: proc { [] }
      attribute :scalar, Harvesting::Assets::ScalarReference.to_array_type, default: proc { [] }
      attribute :collected, Harvesting::Assets::CollectedReference.to_array_type, default: proc { [] }
    end
  end
end
