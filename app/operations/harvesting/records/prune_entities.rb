# frozen_string_literal: true

module Harvesting
  module Records
    # @see Harvesting::Records::EntitiesPruner
    class PruneEntities < Support::SimpleServiceOperation
      service_klass Harvesting::Records::EntitiesPruner
    end
  end
end
