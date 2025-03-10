# frozen_string_literal: true

module Harvesting
  module Attempts
    # @see Harvesting::Attempts::Creator
    class Create < Support::SimpleServiceOperation
      service_klass Harvesting::Attempts::Creator
    end
  end
end
