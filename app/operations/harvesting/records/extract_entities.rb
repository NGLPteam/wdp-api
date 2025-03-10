# frozen_string_literal: true

module Harvesting
  module Records
    # @see Harvesting::Records::EntitiesExtractor
    class ExtractEntities < Support::SimpleServiceOperation
      service_klass Harvesting::Records::EntitiesExtractor
    end
  end
end
