# frozen_string_literal: true

module Harvesting
  module Sources
    # @see Harvesting::Sources::Checker
    class Check < Support::SimpleServiceOperation
      service_klass Harvesting::Sources::Checker
    end
  end
end
