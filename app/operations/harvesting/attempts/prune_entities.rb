# frozen_string_literal: true

module Harvesting
  module Attempts
    # @see Harvesting::Attempts::EntitiesPruner
    class PruneEntities < Support::SimpleServiceOperation
      service_klass Harvesting::Attempts::EntitiesPruner
    end
  end
end
