# frozen_string_literal: true

module Harvesting
  module Sources
    # @see Harvesting::Sources::EntitiesPruner
    class PruneEntities < Support::SimpleServiceOperation
      service_klass Harvesting::Sources::EntitiesPruner
    end
  end
end
