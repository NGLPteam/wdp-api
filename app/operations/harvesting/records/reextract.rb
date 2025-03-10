# frozen_string_literal: true

module Harvesting
  module Records
    # @see Harvesting::Records::Reextractor
    class Reextract < Support::SimpleServiceOperation
      service_klass Harvesting::Records::Reextractor
    end
  end
end
