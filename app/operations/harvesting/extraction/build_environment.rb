# frozen_string_literal: true

module Harvesting
  module Extraction
    # @see Harvesting::Extraction::EnvironmentBuilder
    class BuildEnvironment < Support::SimpleServiceOperation
      service_klass Harvesting::Extraction::EnvironmentBuilder
    end
  end
end
