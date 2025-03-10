# frozen_string_literal: true

module Harvesting
  module Entities
    # @see Harvesting::Entities::AssetsUpserter
    class UpsertAssets < Support::SimpleServiceOperation
      service_klass Harvesting::Entities::AssetsUpserter
    end
  end
end
