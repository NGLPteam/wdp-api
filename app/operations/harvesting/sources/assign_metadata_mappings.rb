# frozen_string_literal: true

module Harvesting
  module Sources
    # @see Harvesting::Sources::MetadataMappingsAssigner
    class AssignMetadataMappings < Support::SimpleServiceOperation
      service_klass Harvesting::Sources::MetadataMappingsAssigner
    end
  end
end
