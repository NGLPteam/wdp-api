# frozen_string_literal: true

module Harvesting
  module Assets
    class ScalarReference
      include StoreModel::Model

      attribute :full_path, :string
      attribute :asset, Harvesting::Assets::ExtractedSource.to_type

      validates :full_path, presence: true
    end
  end
end
