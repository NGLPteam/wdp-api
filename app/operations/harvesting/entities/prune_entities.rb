# frozen_string_literal: true

module Harvesting
  module Entities
    # @see Harvesting::Entities::EntitiesPruner
    class PruneEntities < Support::SimpleServiceOperation
      service_klass Harvesting::Entities::EntitiesPruner
    end
  end
end
