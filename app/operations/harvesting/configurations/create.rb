# frozen_string_literal: true

module Harvesting
  module Configurations
    # @see Harvesting::Configurations::Creator
    class Create < Support::SimpleServiceOperation
      service_klass Harvesting::Configurations::Creator
    end
  end
end
